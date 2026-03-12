# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html) and to [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/).


## v0.21.3 (2026-03-12)

### CI
- Replace changelog action with git-cliff and add release workflow [`75f96d5`](https://github.com/tomhoover/git-wt/commit/75f96d5c4072bd279dbbd9f60407d079e36f8ea1)

### Documentation
- :robot: changelog file generated [`f3755ad`](https://github.com/tomhoover/git-wt/commit/f3755ad2f1895bcc8b6e0ac81a7adc6266a4f6a3)
## v0.21.2 (2026-03-12)

### Documentation
- :robot: changelog file generated [`fc8a5c9`](https://github.com/tomhoover/git-wt/commit/fc8a5c9f57fcef41286614f32630746810908541)

### Test
- Preserve existing .git-wt-copy during no-copy test [`74bfb05`](https://github.com/tomhoover/git-wt/commit/74bfb05b8f0850dda9f57a4c2904a8ccac380c4a)
- Save/restore .git-wt-copy around every test via setup/teardown [`8b624c7`](https://github.com/tomhoover/git-wt/commit/8b624c7be6648e94141b61b694f428a26ffbcd36)
## v0.21.1 (2026-03-12)

### Bug Fixes
- Show resolved worktree name in remove success message [`55a49cd`](https://github.com/tomhoover/git-wt/commit/55a49cd269b64e6f709edcc7f9e5b6430647a17f)

### Test
- Remove .git-wt-copy teardown_file cleanup [`b3dd9d7`](https://github.com/tomhoover/git-wt/commit/b3dd9d70c93a8630feea3399d56257fdad85d820)
## v0.21.0 (2026-03-12)

### Documentation
- :robot: changelog file generated [`10c2356`](https://github.com/tomhoover/git-wt/commit/10c23566ab7bb4c7cf6078ad35fa738d1c6c53d5)

### Feature
- Copy untracked files/dirs to new worktree via .git-wt-copy [`c3cdba6`](https://github.com/tomhoover/git-wt/commit/c3cdba6d489056c8f9616c765ecfbc4561ec21c7)
## v0.20.6 (2026-03-12)

### Documentation
- :robot: changelog file generated [`d410ba5`](https://github.com/tomhoover/git-wt/commit/d410ba54763a39f55c55ba089fa6ee9e2e3bb0cc)

### Test
- Fix version extraction after linter removed quotes from VERSION [`7f2db71`](https://github.com/tomhoover/git-wt/commit/7f2db7124ba144afd994f754d02d2324f92fa833)
## v0.20.5 (2026-03-12)

### Bug Fixes
- Suppress phantom detached entry in list and status output [`af8e5bd`](https://github.com/tomhoover/git-wt/commit/af8e5bdaad4602914873ccb477bde0c7bea42d2a)

### Documentation
- :robot: changelog file generated [`b877d06`](https://github.com/tomhoover/git-wt/commit/b877d06aa0d16d01cc068dbd862a1c8d65e93be7)
## v0.20.4 (2026-03-11)

### Bug Fixes
- Wt cd nonexistent silently no-ops [`d1d7427`](https://github.com/tomhoover/git-wt/commit/d1d742708065e5e771082e0976508ac456eb85da)
## v0.20.3 (2026-03-11)

### Bug Fixes
- Reject flags that appear after the worktree name in remove command [`85ad587`](https://github.com/tomhoover/git-wt/commit/85ad5871563695f775e67871a71701bd8024d442)
## v0.20.2 (2026-03-11)

### Bug Fixes
- Distinguish directory missing vs inaccessible in list output [`ea4a6f3`](https://github.com/tomhoover/git-wt/commit/ea4a6f3b9fb55a53779b2e439ef1e15afaf30a50)

### Documentation
- :robot: changelog file generated [`4e04a57`](https://github.com/tomhoover/git-wt/commit/4e04a575de379890f0e657e0361f33b155e8806e)
## v0.20.1 (2026-03-11)

### Bug Fixes
- Awk reads past detached-HEAD block when extracting branch for remove -d [`35e0522`](https://github.com/tomhoover/git-wt/commit/35e05228225caae7c45792fb45336763b143d88f)
## v0.20.0 (2026-03-11)

### Documentation
- :robot: changelog file generated [`fb93ac8`](https://github.com/tomhoover/git-wt/commit/fb93ac8b5ab49dfab887ed1f8dce7fb3381c7744)

### Feature
- Automatically run mise trust on newly added worktree [`8dfc2cb`](https://github.com/tomhoover/git-wt/commit/8dfc2cb4d57a37e5c8d6082f75051657f97006c8)
## v0.19.4 (2026-03-10)

### Bug Fixes
- Distinguish broken (!!) from dirty (!) in list output (#11) [`2c8dbc1`](https://github.com/tomhoover/git-wt/commit/2c8dbc1124a43ee7300d64be80dcabc0d508a645)
- Show actionable git error when worktree add fails; fix list test regex [`96fe1da`](https://github.com/tomhoover/git-wt/commit/96fe1da5dc0cbaaf70740bbd85fd58b59d75832a)

### Documentation
- :robot: changelog file generated [`a86173d`](https://github.com/tomhoover/git-wt/commit/a86173ddad073b08a8da2dc77768d9b276f84ef9)
- :robot: changelog file generated [`691d010`](https://github.com/tomhoover/git-wt/commit/691d01004e638b097c53bdddd776f71494c53069)
## v0.19.3 (2026-03-10)

### Bug Fixes
- Detect broken/inaccessible worktrees in status and list; add test coverage for slash-branch remove and broken status [`e0cd9bb`](https://github.com/tomhoover/git-wt/commit/e0cd9bb46425126802d66678a56b66a7cccdbbbe)
## v0.19.2 (2026-03-10)

### Refactor
- Address inconsistencies and minor issues [`6ccd43f`](https://github.com/tomhoover/git-wt/commit/6ccd43f9fef576437e3c546f35173b058478caff)
## v0.19.1 (2026-03-10)

### Bug Fixes
- Surface first-attempt error in add, detect broken worktrees in status, warn on detached-HEAD remove -d; add missing tests [`f5279ee`](https://github.com/tomhoover/git-wt/commit/f5279ee5caffc5dfa2727ba591da1cde98685215)
## v0.19.0 (2026-03-10)

### CI
- Add Claude Code GitHub Workflow (#10) [`ab51092`](https://github.com/tomhoover/git-wt/commit/ab510926d29523f8b2933feaa6ff0adce2d35fb4)

### Documentation
- :robot: changelog file generated [`ffb7bca`](https://github.com/tomhoover/git-wt/commit/ffb7bca25cd3261f3f753f50261574cfcbf67a03)
- :robot: changelog file generated [`6a75110`](https://github.com/tomhoover/git-wt/commit/6a75110a115d8fa0b1e912174abc220a2185ef60)

### Feature
- Support slash branches and prefix matching in remove [`21d594a`](https://github.com/tomhoover/git-wt/commit/21d594a9e04d8c5edda5cda7176c57931fb710f8)
## v0.18.6 (2026-03-10)

### Documentation
- Document partial name matching and fzf behaviour for 'wt cd' [`ead324a`](https://github.com/tomhoover/git-wt/commit/ead324ab57b23c5e290370cddde5e9c27af6de92)
## v0.18.5 (2026-03-09)

### Refactor
- Remove dead variable, hoist locals, reduce git calls [`bbb1513`](https://github.com/tomhoover/git-wt/commit/bbb1513291a39f2d8235bd07bbc0f4d24356524e)
## v0.18.4 (2026-03-09)

### Refactor
- Polish status_worktrees() and add_worktree() [`ad49472`](https://github.com/tomhoover/git-wt/commit/ad494723d32bb1846540c5ba3c10f37cec1ca4a7)
## v0.18.3 (2026-03-09)

### Refactor
- Clean up dead code and minor issues in src/git-wt [`9c74377`](https://github.com/tomhoover/git-wt/commit/9c743772566e422f153f511b9564c92fac23a48a)
## v0.18.2 (2026-03-09)

### Bug Fixes
- Sync completion files with embedded completions in src/git-wt [`430d6e9`](https://github.com/tomhoover/git-wt/commit/430d6e9fa7fced2394e5e014cffa4b5480f9f131)

### Documentation
- :robot: changelog file generated [`2b0a69b`](https://github.com/tomhoover/git-wt/commit/2b0a69b02f56d88b89a5e5bbb361066a0de05508)
## v0.18.1 (2026-03-09)

### Documentation
- :robot: changelog file generated [`cfc5699`](https://github.com/tomhoover/git-wt/commit/cfc5699e3159b974635d64b44a63d6c5008885b0)
- Remove obsolete -d and --verbose flags from README; bump to 0.18.1 [`2595e57`](https://github.com/tomhoover/git-wt/commit/2595e57ccbefbf6bf859245d6cb683a7e0a2cbd4)
## v0.18.0 (2026-03-09)

### Refactor
- Remove VERBOSE flag; prune always runs with -v [`40751db`](https://github.com/tomhoover/git-wt/commit/40751db2c321826dc7fc4fcb2cd15db5b88732c1)
## v0.17.0 (2026-03-09)

### Bug Fixes
- Remove -d shorthand for --debug to resolve collision with --delete-branch [`e2b2892`](https://github.com/tomhoover/git-wt/commit/e2b2892bd4e16bb2cc26a98cc91e64673af94d04)
## v0.16.5 (2026-03-09)

### Test
- Add bats_remote defensive cleanup to teardown_file [`3409e2b`](https://github.com/tomhoover/git-wt/commit/3409e2b620c3535a50000d1269bb45405fbc28ab)
## v0.16.4 (2026-03-09)

### Refactor
- Extract _git_wt_worktree_branches helper in zsh completion [`e709ea6`](https://github.com/tomhoover/git-wt/commit/e709ea65c98606060303c688f462aec96ca3879f)
## v0.16.3 (2026-03-09)

### Chore
- Bump version to 0.16.3 [`cb762c6`](https://github.com/tomhoover/git-wt/commit/cb762c6eebf8d0df3c18aff9f5f94f2255a8f63f)
## v0.16.2 (2026-03-09)

### Chore
- Bump version to 0.16.2 [`bc31d3e`](https://github.com/tomhoover/git-wt/commit/bc31d3e9c94ee92fad1a788cf99ba697cc20d287)

### Documentation
- :robot: changelog file generated [`55f59bf`](https://github.com/tomhoover/git-wt/commit/55f59bf65f8d69e688aa30933ab95196edee62d8)
## v0.16.1 (2026-03-09)

### CI
- Generate Changelog based on Conventional Commits [`2b3b059`](https://github.com/tomhoover/git-wt/commit/2b3b05972c3d3dce2c6163f709e917db8bce38e9)
## v0.16.0 (2026-03-09)

### Feature
- Add --delete-branch flag to remove command [`52d9008`](https://github.com/tomhoover/git-wt/commit/52d9008c3f19d0de2658bb4e0a999721389801ca)
## v0.15.0 (2026-03-09)

### Feature
- Fzf integration for wt cd [`c821a0f`](https://github.com/tomhoover/git-wt/commit/c821a0f0b70e0e69d681b4c3468db823d591f538)
## v0.14.0 (2026-03-09)

### CI
- Add GitHub Actions workflow to run lint and bats tests [`d1f60e5`](https://github.com/tomhoover/git-wt/commit/d1f60e5399db605f346e44e8c8a0385a16620729)
- Checkout branch by name to avoid detached HEAD in tests [`1fd45c1`](https://github.com/tomhoover/git-wt/commit/1fd45c11e9659e36416a79f4517b65d2aa214eca)
- Ensure HEAD is on a named branch to fix list tests [`7259a4e`](https://github.com/tomhoover/git-wt/commit/7259a4e49499319f9999aa401d928bfa3a53fab6)

### Documentation
- Fix typo in README.md (#5) [`09c3cb3`](https://github.com/tomhoover/git-wt/commit/09c3cb3562557819c9a321bc49562fab2fbaaaea)

### Feature
- Add 'cd <TAB>' completion for wt alias [`6efd1ba`](https://github.com/tomhoover/git-wt/commit/6efd1baf24b2a46f8bd81a54c7e8b0499e8513bc)

### Test
- Add missing status tests for dirty worktree and current worktree marker [`aaec6a1`](https://github.com/tomhoover/git-wt/commit/aaec6a1864e306d38ccfd360b1e9d8f58616d091)
- Add missing coverage for list, cd, and verbose flag tests [`aa5c064`](https://github.com/tomhoover/git-wt/commit/aa5c064cded20c72715146e7a292510c8ed72e29)
- Broaden list assertions to match any branch name [`9ad1110`](https://github.com/tomhoover/git-wt/commit/9ad111049a70809de8cab556330ef06eadd0ed09)
## v0.13.0 (2026-03-09)

### Bug Fixes
- Exclude merge commits from conventional commit check [`a03a0da`](https://github.com/tomhoover/git-wt/commit/a03a0dac6814caba593779906c33a44141d9c026)

### CI
- Add GitHub Actions workflow to enforce conventional commits [`71b6f6e`](https://github.com/tomhoover/git-wt/commit/71b6f6ed10abbc4617062c1f077a5dec7d4fcf12)

### Feature
- Add a 'dirty' indicator to the 'list' command [`cdb3d67`](https://github.com/tomhoover/git-wt/commit/cdb3d67039b99524de3bade3b0650fc096f89318)
## v0.12.1 (2026-03-08)

### Documentation
- Add additional examples to 'Usage' [`c18b09d`](https://github.com/tomhoover/git-wt/commit/c18b09d845738bf93c0b9320dc94fe8ce5ef6604)
## v0.12.0 (2026-03-08)

### Feature
- Show wt-aware usage when called via wrapper function [`38e9fe6`](https://github.com/tomhoover/git-wt/commit/38e9fe6a6f4f5c841faf444f63b5083409a4e4e2)
## v0.11.1 (2026-03-08)

### Documentation
- Clarification of 'remove' command options (-f|--force) [`599e263`](https://github.com/tomhoover/git-wt/commit/599e263a90c1b28002fce4a86ca0ba1c377b7b61)
## v0.11.0 (2026-03-08)

### Documentation
- Add MIT license [`6827470`](https://github.com/tomhoover/git-wt/commit/68274701cfdba22f906e80d70fc4e67b09f1bc9a)

### Feature
- Improve bash completion and move -f flag to remove subcommand [`eb59dc4`](https://github.com/tomhoover/git-wt/commit/eb59dc44b6173683d8e1a5ff05b91654691e6774)

### Refactor
- Vim folding [`6dbe6be`](https://github.com/tomhoover/git-wt/commit/6dbe6bef34aa9b06bfcd98e92e35918ec8aa9c54)
## v0.10.0 (2026-03-07)

### Feature
- Rename switch→cd, add status subcommand [`afe5ea4`](https://github.com/tomhoover/git-wt/commit/afe5ea4e7c1d679646670740474a3c373d129a21)
## v0.9.0 (2026-03-07)

### Feature
- Add init subcommand for shell integration [`f32e6ff`](https://github.com/tomhoover/git-wt/commit/f32e6fff4c510d008224fc2fc4b967ffc569286b)
## v0.8.0 (2026-03-07)

### Chore
- Bump version to 0.8.0 [`70737ad`](https://github.com/tomhoover/git-wt/commit/70737ad979516bd6a032672e02a37ca0f87bdcb0)

### Feature
- Add prefix matching to switch subcommand [`3ce0756`](https://github.com/tomhoover/git-wt/commit/3ce0756f5fcca122ddc03f7f3c5e49c90bfae9a8)
## v0.7.2 (2026-03-07)

### Feature
- Show (new branch) or (existing branch) after add [`e106437`](https://github.com/tomhoover/git-wt/commit/e1064372dc109afa94a9aa3c032098805fb0944b)
## v0.7.1 (2026-03-07)

### Feature
- Improve list output with * marker and color [`1db18d6`](https://github.com/tomhoover/git-wt/commit/1db18d647c6740f3d1a9f943a3ce639c12c5207a)
## v0.7.0 (2026-03-06)

### Chore
- Bump version to 0.7.0 [`da06072`](https://github.com/tomhoover/git-wt/commit/da06072bf6dff36eaff33a3e1b1edf2326a71771)
- Add src/ to PATH via mise and update tests [`ffbe64f`](https://github.com/tomhoover/git-wt/commit/ffbe64fb800bce7330dddfedf03d99c9b65b72c0)
## v0.6.3 (2026-03-05)

### Documentation
- Remove development section from README [`5b5a424`](https://github.com/tomhoover/git-wt/commit/5b5a42491b87c2fc10008d41a0dd7e31f97296f7)
## v0.6.2 (2026-03-05)

### Test
- Verify -v flag is forwarded to git worktree prune [`1305cd0`](https://github.com/tomhoover/git-wt/commit/1305cd03377155e4c2e460dc6c7c74b273f0dfb5)
## v0.6.1 (2026-03-05)

### Feature
- Add completion subcommand for eval-based shell setup [`48fe5eb`](https://github.com/tomhoover/git-wt/commit/48fe5ebd8cb9e3e6da7ec5c43d8d04b73111c55d)
## v0.6.0 (2026-03-05)

### Chore
- Bump version to 0.5.1 [`98b7939`](https://github.com/tomhoover/git-wt/commit/98b7939be883ae0e1286eacb7b8738ddfe932afd)
- Bump version to 0.6.0 [`0c9da7d`](https://github.com/tomhoover/git-wt/commit/0c9da7d5233dd281f055db32666ed7b515990b5d)

### Feature
- Add shell completion for zsh and bash [`1509a78`](https://github.com/tomhoover/git-wt/commit/1509a782996c3d391ca7c4c197be33572a5e4e62)
## v0.5.1 (2026-03-05)

### Feature
- Switch with no args returns main worktree path [`7f5fea3`](https://github.com/tomhoover/git-wt/commit/7f5fea31625d2b128ce0f5d8811121077e0cd37d)
## v0.5.0 (2026-03-05)

### Feature
- Add no-args support to add command [`55032a8`](https://github.com/tomhoover/git-wt/commit/55032a8191ca3b1d39f9e560a7436ec000e38a9a)
## v0.4.0 (2026-03-05)

### Chore
- Bump version to 0.4.0 [`b039435`](https://github.com/tomhoover/git-wt/commit/b0394353bca9a13a456f149203430066a1539785)

### Feature
- Add switch command to print worktree path [`f17cfa0`](https://github.com/tomhoover/git-wt/commit/f17cfa02b047bf4680fbb5d35d8ab31cae186d15)
## v0.3.0 (2026-03-05)

### Chore
- Update pre-commit hooks [`f4abb0a`](https://github.com/tomhoover/git-wt/commit/f4abb0af9fec1a35673beda672c92cd2378a2306)
- Add tools to mise.toml [`55951c0`](https://github.com/tomhoover/git-wt/commit/55951c08fe34f1244c6fdea20bf346b6edbf016a)
- Improve Makefile [`7fa6ec5`](https://github.com/tomhoover/git-wt/commit/7fa6ec57086989a7b5982ea13b4e3eeddef6d473)

### Documentation
- Rewrite README [`39a74ee`](https://github.com/tomhoover/git-wt/commit/39a74eec5548af08d1bb66d9529f43e1ee05c908)

### Refactor
- Rename test/.bats_deps to test/libs [`5df8d5e`](https://github.com/tomhoover/git-wt/commit/5df8d5eb60e775592d2bde3dff00346437c2bbf9)

### Style
- Switch to 2-space indent [`69a990d`](https://github.com/tomhoover/git-wt/commit/69a990d8cb716cd6a84151f95c045438e6af977d)
## v0.1.0 (2026-03-02)
