let GithubActions =
      https://raw.githubusercontent.com/gvolpe/github-actions-dhall/steps/cachix/package.dhall sha256:33c360447910bdb69f89d794e3579dc7c77c0128d0fcddb90b4cd30b96f52648

let AuthSchema =
      https://raw.githubusercontent.com/gvolpe/github-actions-dhall/steps/cachix/steps/JamesIves/AuthSchema.dhall sha256:d7db887a6d0c63cb42f8d0915fd5484791afa213192b5f12525fef25c42cf521

let setup =
      [   GithubActions.steps.checkout
        // { with = Some (toMap { persist-credentials = "false" }) }
      , GithubActions.steps.cachix/install-nix
      , GithubActions.steps.cachix/cachix { cache-name = "gvolpe-site" }
      ,   GithubActions.steps.run
            { run = "nix-shell --run \"npm install && hexo generate\"" }
        // { name = Some "Building site 🚧" }
      , GithubActions.steps.JamesIves/ghpages-deploy
          { authSchema = AuthSchema.accessToken
          , branch = "master"
          , folder = "public"
          , opts = toMap
              { GIT_CONFIG_NAME = "Gabriel Volpe"
              , REPOSITORY_NAME = "gvolpe/gvolpe.github.io"
              }
          }
      ]

let publishJob =
      GithubActions.Job::{
      , runs-on = GithubActions.types.RunsOn.`ubuntu-18.04`
      , steps = setup
      }

in  GithubActions.Workflow::{
    , name = "Site"
    , on = GithubActions.On::{
      , push = Some GithubActions.Push::{
        , branches = Some [ "master" ]
        , paths = Some [ "source/**", "themes/**" ]
        }
      }
    , jobs = toMap { publish = publishJob }
    }
