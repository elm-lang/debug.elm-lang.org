import Distribution.Simple
import Distribution.Simple.Setup
import Distribution.Simple.LocalBuildInfo
import Distribution.PackageDescription

import System.IO
import System.Exit
import System.Process
import Control.Monad
import System.FilePath
import System.Directory

main :: IO ()
main = defaultMainWithHooks simpleUserHooks { postBuild = myPostBuild }

myPostBuild :: Args -> BuildFlags -> PackageDescription -> LocalBuildInfo -> IO ()
myPostBuild args flags pd lbi =
  do putStrLn "Building debug panel interface"
     buildInterface ("elm-server" </> "slider")
     concatJS
     copyPanelImages


buildInterface :: FilePath -> IO ()
buildInterface workingDir =
    do exitCode <- compile $ args "debuggerInterface.elm"
       case exitCode of
            ExitFailure _ ->
                putStrLn "Build failed: debuggerInterface"
            ExitSuccess ->
                do let compiledFile = workingDir </> "build" </> "debuggerInterface.js"
                   let destinationFile = "elm-server" </> "assets" </> "_reactor" </> "debuggerInterface.js"
                   copyFile compiledFile destinationFile
                   removeFile compiledFile
       removeEverything workingDir "Slider.elm"
       removeEverything workingDir "debuggerInterface.elm"
    where
        args file =
            [ "--make"
            , "--only-js"
            , file
            ]

        compile args =
            do let workingDir' = Just workingDir
               handle <- runProcess "elm" args workingDir' Nothing Nothing Nothing Nothing
               exitCode <- waitForProcess handle
               return exitCode

        removeEverything dir file =
            do remove "cache" "elmi"
               remove "cache" "elmo"
               remove "build" "js"
            where
                remove :: String -> String -> IO ()
                remove subdir ext =
                    do let path = dir </> subdir </> file`replaceExtension` ext
                       exists <- doesFileExist path
                       when exists (removeFile path)

concatJS :: IO ()
concatJS =
  do let files =
          [ "elm-server" </> "assets" </> "_reactor" </> "debuggerInterface.js"
          , "elm-server" </> "assets" </> "_reactor" </> "toString.js"
          , "elm-server" </> "assets" </> "_reactor" </> "core.js"
          , "resources" </> "debugger" </> "debug-panel.js"
          ]
     megaJS <- concat `fmap` mapM readFile files
     _ <- putStrLn "Writing composite debugger.js"
     writeFile ("resources" </> "debugger.js") megaJS

copyPanelImages :: IO ()
copyPanelImages =
  do let serverImageDir = "elm-server" </> "assets" </> "_reactor" </> "debugger"
     files <- getDirectoryContents serverImageDir
     let images = filter (\x -> ".png" == takeExtensions x) files
     let destinationDir = "resources" </> "_reactor" </> "debugger"
     createDirectoryIfMissing True destinationDir
     let srcImgs = map (serverImageDir </>) images
     let destImgs = map (destinationDir </>) images
     mapM_ (uncurry copyFile) $ zip srcImgs destImgs

