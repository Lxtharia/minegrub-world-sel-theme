-- module Main(main) where


import System.Process (runCommand)
import System.Process (waitForProcess)
import Text.Printf (printf)

type Arguments = (String, String, String, String, Int)

distroList = [
    ("arch", "Arch Linux", "11/02/2002/", "6.5.3", 1343),
    ("debian", "Debian", "11/02/2002/", "6.1.0", 1927),
    ("ubuntu", "Ubuntu", "11/02/2002/", "6.2.4", 1712),
    ("nixos", "NixOS", "11/02/2002/", "6.5.3", 1543),
    ("gentoo", "Gentoo", "11/02/2002/", "6.5.3", 1143),
    ("void", "Void Linux", "11/02/2002/", "6.5.3", 1378),
    ("pop-os", "PopOS", "11/02/2002/", "6.5.3", 1530)
    ]

makeCommand :: Arguments -> String
makeCommand a = printf "echo Processing icon for %s ; cargo run '%s' '%s (%s %s)' 'Creative Mode, Cheats, %d Packages' './distro-icons/distributor-logo-%s.png' '../minegrub-world-selection/icons'\n " classname classname distroname distrodate kernelversion packagecount classname
            where (classname, distroname, distrodate, kernelversion, packagecount) = a 

runCommands :: [Arguments] -> IO ()
runCommands [] = return ()
runCommands (c:a) = do 
                 waitForProcess <- runCommand $ makeCommand c
                 runCommands a

main :: IO ()
main = do 
    runCommands distroList

    return ()

