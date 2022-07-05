{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -w #-}
module Paths_superrecord (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where


import qualified Control.Exception as Exception
import qualified Data.List as List
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude


#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,5,1,0] []

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir `joinFileName` name)

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath



bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath
bindir     = "/home/goosedb/.cabal/bin"
libdir     = "/home/goosedb/.cabal/lib/x86_64-linux-ghc-8.10.7/superrecord-0.5.1.0-inplace"
dynlibdir  = "/home/goosedb/.cabal/lib/x86_64-linux-ghc-8.10.7"
datadir    = "/home/goosedb/.cabal/share/x86_64-linux-ghc-8.10.7/superrecord-0.5.1.0"
libexecdir = "/home/goosedb/.cabal/libexec/x86_64-linux-ghc-8.10.7/superrecord-0.5.1.0"
sysconfdir = "/home/goosedb/.cabal/etc"

getBinDir     = catchIO (getEnv "superrecord_bindir")     (\_ -> return bindir)
getLibDir     = catchIO (getEnv "superrecord_libdir")     (\_ -> return libdir)
getDynLibDir  = catchIO (getEnv "superrecord_dynlibdir")  (\_ -> return dynlibdir)
getDataDir    = catchIO (getEnv "superrecord_datadir")    (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "superrecord_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "superrecord_sysconfdir") (\_ -> return sysconfdir)




joinFileName :: String -> String -> FilePath
joinFileName ""  fname = fname
joinFileName "." fname = fname
joinFileName dir ""    = dir
joinFileName dir fname
  | isPathSeparator (List.last dir) = dir ++ fname
  | otherwise                       = dir ++ pathSeparator : fname

pathSeparator :: Char
pathSeparator = '/'

isPathSeparator :: Char -> Bool
isPathSeparator c = c == '/'
