{-# LANGUAGE OverloadedStrings #-}

module BeholderObserver.Constant (
ConstantDataLoader(..)
) where

import BeholderObserver.Data

data ConstantDataLoader = ConstantDataLoader

-------------------------------------
-- Data we're exposing. See below for typeclass
-- implementation.

projects = [
              Project "infinity-ide" "Infinity IDE" [
                DocSet "llvm" "LLVM" [],
                DocSet "titandb" "TitanDB" [],
                DocSet "neo4j" "Neo4J" [],
                DocSet "sql" "SQL" [],
                DocSet "compilers" "Compilers" [],
                DocSet "refactoring" "Refactoring" [],
                DocSet "formal-methods" "Formal Methods" [],
                DocSet "graph-algorithms" "Graph Algorithms" [],
                DocSet "comparison-of-ides" "Comparison of IDEs" [],
                DocSet "specification" "Specification" [],
                DocSet "version-control" "Version Control" []
              ],
              Project "genealogy" "Genealogy" [],
              Project "vr-os" "Virtual Reality OS" [
                DocSet "vr-headsets" "VR Headsets" [],
                DocSet "process-management" "Process Management" [],
                DocSet "processor-boot-sequences" "Processor Boot Sequences" [],
                DocSet "kernel-design" "Kernel Design Analysis" [],
                DocSet "filesystems" "Filesystems" [],
                DocSet "hw-sw-interface" "Harware/Software Interface" []
              ],
              Project "weary-examiner" "Weary Examiner" [
                DocSet "riak" "Riak" [],
                DocSet "sql" "SQL" [],
                DocSet "table-reqs" "Table Requirements" [],
                DocSet "server-reqs" "Server Requirements" [],
                DocSet "docker" "Docker" [],
                DocSet "radio-tech" "Radio Tech" [],
                DocSet "ui-mockups" "UI Mockups" []
              ],
              Project "website" "Website" [],
              Project "kanban-boards" "Kanban Boards" [],
              Project "pipelang" "PipeLang" [],
              Project "bi-system" "BI System" [],
              Project "ddos-web-server" "DDoS-resistant Web Server" []
            ]


-------------------------------------
-- Typeclass implementation.
instance DataLoader ConstantDataLoader where
  listProjects dl = return projects
  readDocSets dl = return . projDocSets
  readDocs dl = return . dsDocs
  findDoc dl _ = return []
