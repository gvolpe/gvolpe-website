let GithubActions =
      https://raw.githubusercontent.com/gvolpe/github-actions-dhall/steps/cachix/package.dhall sha256:33c360447910bdb69f89d794e3579dc7c77c0128d0fcddb90b4cd30b96f52648

let setup =
      [ GithubActions.steps.checkout
      , GithubActions.steps.cachix/install-nix
      , GithubActions.steps.cachix/cachix { cache-name = "gvolpe-site" }
      , GithubActions.steps.run
          { run = "nix-shell --run \"npm install && hexo generate\"" } // { name = Some "Building site 🚧" }
      ]

in  GithubActions.Workflow::{
    , name = "Site"
    , on = GithubActions.On::{
      , pull_request = Some GithubActions.PullRequest::{=}
      , push = Some GithubActions.Push::{ branches = Some [ "master" ] }
      }
    , jobs = toMap
        { build = GithubActions.Job::{
          , needs = None (List Text)
          , runs-on = GithubActions.types.RunsOn.`ubuntu-18.04`
          , steps = setup
          }
        }
    }
