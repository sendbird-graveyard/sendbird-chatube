#!/usr/bin/env python
#
# Copyright 2007 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
import webapp2
import logging
import json
import uuid
from models import *
import urllib
import urllib2


class MainHandler(webapp2.RequestHandler):
  def get(self):
    self.response.write('SendBird Sample Server')


class UserSignIn(webapp2.RequestHandler):
  def post(self):
    data = json.loads(self.request.body)
    user_list = User.query(User.email == data['email']).fetch(1)
    if len(user_list) > 0:
      user = user_list[0]
      if user.password == User.password_encrypt(data['password']):
        user.device_token = data['device_token']
        user.device_type = data['device_type']
        user.put()
        self.response.write(json.dumps({
            "result": "success",
            "user": user.to_dict()
            }))
        return
      else:
        self.response(json.dumps({
            "result": "error",
            "message": "Password is incorrect."
            }))
        return
    else:
      self.response(json.dumps({
          "result": "error",
          "message": "User not found."
          }))
      return


class UserSignUp(webapp2.RequestHandler):
  def post(self):
    data = json.loads(self.request.body)
    check = User.query(User.email == data['email']).fetch(1)
    if len(check) > 0:
      logging.info("The email exists.")
      self.response.write(json.dumps({
          "result": "error",
          "message": "The email exists."
          }))
      return

    user = User()
    try:
      user.email = data['email']
      user.nickname = data['nickname']
      user.device_token = data['device_token']
      user.device_type = data['device_type']
      user.session = uuid.uuid4().hex
      user.sendbird_id = uuid.uuid4().hex
      user.password = User.password_encrypt(data['password'])
      user.put()
    except:
      logging.info("You cannot sign up.")
      self.response.write(json.dumps({
          "result": "error",
          "message": "You cannot sign up."
          }))
      return

    user_dict = user.to_dict()
    self.response.write(json.dumps({
        "result": "success",
        "user": user_dict
        }))


class UserNickname(webapp2.RequestHandler):
  def post(self):
    data = json.loads(self.request.body)
    logging.info(self.request.body)
    check = User.query(User.session == data['session']).fetch(1)
    if len(check) == 0:
      self.response.write(json.dumps({
          "result": "error",
          "message": "Session is wrong."
          }))
      return

    user = check[0]
    logging.info(user.nickname)
    try:
      logging.info(data['nickname'])
      user.nickname = data['nickname']
      user.put()
    except:
      self.response.write(json.dumps({
          "result": "error",
          "message": "You cannot change a nickname."
          }))

    user_dict = user.to_dict()
    logging.info("signup success.")
    self.response.write(json.dumps({
        "result": "success",
        "user": user_dict
        }))


class VideoListLoading(webapp2.RequestHandler):
  def post(self):
    data = json.loads(self.request.body)
    offset = data['offset']
    limit = data['limit']
    order_by = data['order_by']

    video_list = []
    if order_by == 1:
      video_list = YouTube.query().order(-YouTube.viewer).fetch(limit, offset=offset)
    else:
      video_list = YouTube.query().order(-YouTube.created_time).fetch(limit, offset=offset)

    video_dict_list = []
    for video in video_list:
      video_dict_list.append(video.to_dict())

    self.response.write(json.dumps({
        "result": "success",
        "video_list": video_dict_list
        }))


class RegisterVideo(webapp2.RequestHandler):
  def post(self):
    data = json.loads(self.request.body)
    youtube = YouTube()
    session = data['session']
    user_list = User.query(User.session == session).fetch(1)
    if len(user_list) > 0:
      owner = user_list[0]

    try:
      youtube_list = YouTube.query(YouTube.video_id == data['video_id']).fetch(1)
      if len(youtube_list) > 0:
        self.response.write(json.dumps({
            "result": "error",
            "message": "The video is already registered."
            }))
        logging.info("The video is already registered.")
        return

      youtube.url = data['url']
      youtube.video_id = data['video_id']
      youtube.title = data['title']
      youtube.owner = owner.key.id()
      youtube.thumbnail = data['thumbnail']

      create_channel_api = "https://api.sendbird.com/channel/create"
      api_token = "<YOUR_APP_API_TOKEN>"
      request_body = {
          'auth': api_token,
          'channel_url': uuid.uuid4().hex,
          'name': data['title'],
          'cover_url': data['thumbnail'],
          'data': ""
          }
      data = json.dumps(request_body)
      req = urllib2.Request(create_channel_api, data, {'Content-Type': 'application/json'})
      f = urllib2.urlopen(req)
      response = f.read()
      logging.info(response)
      channel = json.loads(response)
      channel_url = channel['channel_url']
      youtube.channel_url = channel_url
      youtube.put()
    except:
      logging.info("error")
      self.response.write(json.dumps({
          "result": "error",
          "message": "The video can't be registered."
          }))
      return
    logging.info("success")
    self.response.write(json.dumps({
        "result": "success",
        }))


class ViewVideo(webapp2.RequestHandler):
  def post(self):
    data = json.loads(self.request.body)
    video_id = data['video_id']
    video_list = YouTube.query(YouTube.video_id == video_id).fetch(1)
    if len(video_list) > 0:
      video = video_list[0]
      video.viewer = video.viewer + 1
      video.put()

    self.response.write("{}")


class Webhook(webapp2.RequestHandler):
  def post(self):
    data = json.loads(self.request.body)
    if data['category'] == "messaging:offline_notification":
      logging.info("Sender: {}".format(data['sender']['name']))
    self.response.write("{}")


app = webapp2.WSGIApplication([
    ('/', MainHandler),
    ('/signup', UserSignUp),
    ('/signin', UserSignIn),
    ('/user/nickname', UserNickname),
    ('/webhook', Webhook),
    ('/video/list', VideoListLoading),
    ('/video/register', RegisterVideo),
    ('/video/view', ViewVideo),
], debug=True)
