module Distribution.Server.Util.GZip (
    decompressNamed
  ) where

import qualified Codec.Compression.GZip as GZip
import Control.Exception 
import Data.ByteString.Lazy.Internal 
import qualified Data.ByteString.Lazy.Char8 as BSL

decompressNamed :: String -> ByteString -> ByteString
decompressNamed n bs = 
    mapExceptionRecursive mapError $ GZip.decompress bs 
  where
    mapError (ErrorCall str) = ErrorCall $ str ++ " in " ++ show n ++ " (" ++ show (BSL.unpack (BSL.take 20 bs)) ++ "..)"

mapExceptionRecursive :: (Exception e1, Exception e2) => (e1 -> e2) -> ByteString -> ByteString
mapExceptionRecursive f bs = 
  case mapException f bs of
    Empty      -> Empty
    Chunk b bs -> Chunk b (mapExceptionRecursive f bs)
