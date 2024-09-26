module Types where

import Prelude

import Data.Newtype (class Newtype)
import Yoga.JSON (class ReadForeign, class WriteForeign)

newtype Email = Email String

derive instance Newtype Email _
derive newtype instance Eq Email
derive newtype instance Show Email
derive newtype instance ReadForeign Email
derive newtype instance WriteForeign Email

newtype JwtAccessToken = JwtAccessToken String

derive instance Newtype JwtAccessToken _
derive newtype instance Eq JwtAccessToken
derive newtype instance Show JwtAccessToken
derive newtype instance ReadForeign JwtAccessToken
derive newtype instance WriteForeign JwtAccessToken

newtype JwtRefreshToken = JwtRefreshToken String

derive instance Newtype JwtRefreshToken _
derive newtype instance Eq JwtRefreshToken
derive newtype instance Show JwtRefreshToken
derive newtype instance ReadForeign JwtRefreshToken
derive newtype instance WriteForeign JwtRefreshToken

newtype UserId = UserId String

derive instance Newtype UserId _
derive newtype instance Eq UserId
derive newtype instance Show UserId
derive newtype instance ReadForeign UserId
derive newtype instance WriteForeign UserId
