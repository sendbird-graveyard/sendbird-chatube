from google.appengine.ext import ndb
import calendar
from Crypto.Hash import SHA256


class User(ndb.Model):
  email = ndb.StringProperty(required=True, indexed=True)
  nickname = ndb.StringProperty(required=True, indexed=True)
  password = ndb.StringProperty(required=True)
  session = ndb.StringProperty(required=True)
  sendbird_id = ndb.StringProperty(required=True)
  created_time = ndb.DateTimeProperty(auto_now_add=True)
  updated_time = ndb.DateTimeProperty(auto_now=True)
  device_token = ndb.StringProperty(required=True, indexed=True)
  device_type = ndb.StringProperty(required=True, choices=set(["IOS", "ANDROID", "WEB"]))

  def to_dict(self):
    ret = {
        "email": self.email,
        "nickname": self.nickname,
        "session": self.session,
        "sendbird_id": self.sendbird_id,
        "created_time": calendar.timegm(self.created_time.timetuple()),
        "updated_time": calendar.timegm(self.updated_time.timetuple()),
    }

    return ret

  @staticmethod
  def password_encrypt(plain):
    sha256hash = SHA256.new()
    sha256hash.update(plain)
    hashed = sha256hash.hexdigest()

    return hashed


class YouTube(ndb.Model):
  url = ndb.StringProperty(required=True)
  video_id = ndb.StringProperty(required=True)
  title = ndb.StringProperty(required=True)
  thumbnail = ndb.StringProperty(required=True)
  owner = ndb.IntegerProperty(required=True, indexed=True)
  created_time = ndb.DateTimeProperty(auto_now_add=True, indexed=True)
  updated_time = ndb.DateTimeProperty(auto_now=True)
  channel_url = ndb.StringProperty(required=True)
  viewer = ndb.IntegerProperty(default=0)

  def to_dict(self):
    owner_name = User.get_by_id(self.owner).nickname
    ret = {
        "url": self.url,
        "video_id": self.video_id,
        "title": self.title,
        "thumbnail": self.thumbnail,
        "channel_url": self.channel_url,
        "created_time": calendar.timegm(self.created_time.timetuple()),
        "updated_time": calendar.timegm(self.updated_time.timetuple()),
        "viewer": self.viewer,
        "owner": owner_name,
    }

    return ret
