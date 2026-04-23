# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html) and to [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/).


## v0.25.0 (2026-04-23)

### Bug Fixes
- Handle worktree paths with spaces and reject extra args [`66d78d7`](https://github.com/tomhoover/git-wt/commit/66d78d7eb03f750a41a6e39a71a3d5cfbc703888)
- Trim .git-wt-copy entries with tabs and CRLF [`c8830d5`](https://github.com/tomhoover/git-wt/commit/c8830d5306cb26383b8cfe488b4fa4ea0417476b)
- Improve cd fallback when multiple worktrees exist without fzf [`021a0c1`](https://github.com/tomhoover/git-wt/commit/021a0c10dae6db455dddf858d50d11f5704868a0)

### CI
- Remove claude* workflows [`590950c`](https://github.com/tomhoover/git-wt/commit/590950c7c27f0e2dabfa776696c5d2341ff5d52b)

### Chore
- Use more specific mktemp template in init_shell [`abd40b8`](https://github.com/tomhoover/git-wt/commit/abd40b8dce919920a9680804aa49f4eb58a421fb)

### Documentation
- Expand AGENTS.md with comprehensive developer guidance [`3313295`](https://github.com/tomhoover/git-wt/commit/33132952324293eddac04395dacc900733e0d6ee)
- Add prerequisites and contributing sections to README [`e01b9f2`](https://github.com/tomhoover/git-wt/commit/e01b9f2fd23e4319b438e5469465a73d23acacff)

### Feature
- Add GIT_WT_DEBUG env var for bash trace debugging [`6c01f06`](https://github.com/tomhoover/git-wt/commit/6c01f06c01267d87849d319db6dbec2eb75adf72)
- Add --short flag for script-friendly output [`7d15471`](https://github.com/tomhoover/git-wt/commit/7d15471f064afeac12a26e4c77ae5c0b51e20ccd)
- Require confirmation for partial matches [`efc176c`](https://github.com/tomhoover/git-wt/commit/efc176ceb86981221d26edb93c4e255ef0e877f3)

### Test
- Add tests for GIT_WT_DEBUG env var and cd with no linked worktrees [`83b5672`](https://github.com/tomhoover/git-wt/commit/83b5672aac7523da9144a522cd438984d3ec0fd4)

### Build
- Bump mislav/bump-homebrew-formula-action from 3 to 4 (#19) [`4f8c447`](https://github.com/tomhoover/git-wt/commit/4f8c447acd189ff81bde5a33fe8f166685db910d)
- Bump jdx/mise-action from 3 to 4 (#18) [`d917e03`](https://github.com/tomhoover/git-wt/commit/d917e03aaa223cdd66f01a66772d9f512074f8a6)
## v0.24.3 (2026-03-16)

### Bug Fixes
- Allow .git-wt-copy entries with double dots [`d81c433`](https://github.com/tomhoover/git-wt/commit/d81c433fe744ea9ba21c827c8883130a1f3462ac)

### Chore
- Pin bats deps and tighten test preflight [`86c1b0a`](https://github.com/tomhoover/git-wt/commit/86c1b0a018c75c4687bcc187526e4adba557c064)

### Documentation
- Clarify shell function requirement for '--cd' [`f469a8d`](https://github.com/tomhoover/git-wt/commit/f469a8ddbf50714af14e7fa372937b7595291925)
- Add AGENTS contributor guide [`ec2db6b`](https://github.com/tomhoover/git-wt/commit/ec2db6b45f77205286bb9d8c2ac8c0da1ea40775)
## v0.24.2 (2026-03-15)

### Bug Fixes
- Accept '--' in add/remove and validate branch names [`4fff431`](https://github.com/tomhoover/git-wt/commit/4fff4312ee1786e2d11f73203f0bd84d0bf1fd71)

### Documentation
- Clarify usage and command options [`6c8e2fd`](https://github.com/tomhoover/git-wt/commit/6c8e2fd6d16ec4cd7950138d77ad3ce3fc899a60)
## v0.24.1 (2026-03-15)

### Bug Fixes
- Fixed failing ci test on github [`3eff62c`](https://github.com/tomhoover/git-wt/commit/3eff62cb436ed97bf7c8779a11a5ea77b6920715)
## v0.24.0 (2026-03-15)

### Feature
- Allow remove options before or after worktree name [`64bef5f`](https://github.com/tomhoover/git-wt/commit/64bef5f8016ed1732abfe86539034749f5dd4cd7)
## v0.23.1 (2026-03-13)

### Bug Fixes
- Validate add_worktree early and reject extra args in remove [`b6f881e`](https://github.com/tomhoover/git-wt/commit/b6f881eff73a871972cc8ee014a914e53e450e49)
- Reject extra positional args in add (>2 args after flags) [`6ff6214`](https://github.com/tomhoover/git-wt/commit/6ff6214bc1e37c73de9bbfea94f6846fd64ed4d3)
- Correct .git-wt-copy warning to say 'source worktree' not 'main worktree' [`d99a4a7`](https://github.com/tomhoover/git-wt/commit/d99a4a7545e30e48008c14129d93e9e0bfaee46f)

### Chore
- Guard 'make release' against non-main worktrees [`560fb48`](https://github.com/tomhoover/git-wt/commit/560fb48842286bbf419015630669e65f7ae66dfe)

### Documentation
- Clarify remove, --cd, .git-wt-copy, and cd matching behaviour [`3a4e434`](https://github.com/tomhoover/git-wt/commit/3a4e434fa2358608b0f4192625620f5f9ff3d268)
- Update inline -h help for cd to mention partial match and fzf [`fc11f8d`](https://github.com/tomhoover/git-wt/commit/fc11f8d093010c8f126341693cc0cdc1e5b2f4fe)
- Add additional examples to -h [`72739b5`](https://github.com/tomhoover/git-wt/commit/72739b5dcd945e63def9c9c93ea2a6042272bd13)

### Refactor
- Reduce git worktree list calls and share parser [`2a07b28`](https://github.com/tomhoover/git-wt/commit/2a07b2849e6d02c7c4a6ed4f98fd99dc643ceda2)
- Deduplicate maybe_mise_trust and copy_worktree_files in add_worktree [`12f0b14`](https://github.com/tomhoover/git-wt/commit/12f0b1478574dfdb34350624b48819b467040ad3)
- Eliminate second git worktree list call in remove [`c93be12`](https://github.com/tomhoover/git-wt/commit/c93be120fea921ea8545db9e4b568145c010406a)

### Build
- Bump actions/checkout from 4 to 6 (#16) [`96a8860`](https://github.com/tomhoover/git-wt/commit/96a8860db5f6f2b882fc955128ac9088d0b3912d)
- Bump jdx/mise-action from 2 to 3 (#17) [`e101077`](https://github.com/tomhoover/git-wt/commit/e1010775962e32150a16723110a493730ddaa925)
## v0.23.0 (2026-03-12)

### Feature
- Honor NO_COLOR to disable color output [`9d71477`](https://github.com/tomhoover/git-wt/commit/9d71477115bb7100ee7533c9e74571feb0fa91a9)
## v0.22.2 (2026-03-12)

### CI
- Fix Homebrew tap update trigger [`076a4b9`](https://github.com/tomhoover/git-wt/commit/076a4b959f54887b718b916c3671fcff15014730)
## v0.22.1 (2026-03-12)

### Test
- Fix base-branch test to use current branch instead of 'master' [`648c692`](https://github.com/tomhoover/git-wt/commit/648c692af577679bc9d0ecf2fbc100bf235c4c39)
## v0.22.0 (2026-03-12)

### CI
- Skip Claude code review for Dependabot PRs [`19bf3f7`](https://github.com/tomhoover/git-wt/commit/19bf3f721e4758950cfe56f43d121864b291cb04)

### Feature
- Support optional base branch in git wt add [`0b97929`](https://github.com/tomhoover/git-wt/commit/0b97929b328864517b17c0213f6035fd46e5da33)
- Add --cd flag to wt add and fix base branch worktree path [`4f520f1`](https://github.com/tomhoover/git-wt/commit/4f520f169da30ae28876838757bae48ece8ceece)
## v0.21.4 (2026-03-12)

### CI
- Add workflow to auto-update Homebrew tap on release [`e93558e`](https://github.com/tomhoover/git-wt/commit/e93558ecc9c9b475a8ef9e23ccd6e4ae18ca6dc9)

### Chore
- Add dependabot for GitHub Actions version updates [`76e4a42`](https://github.com/tomhoover/git-wt/commit/76e4a424bc6ffefaf414463989f253de9ccf0ceb)

### Build
- Add git-cliff to check-tools [`5333ef2`](https://github.com/tomhoover/git-wt/commit/5333ef2566ee737e4ebfa448937d75d1e43f3374)
## v0.21.3 (2026-03-12)

### CI
- Replace changelog action with git-cliff and add release workflow [`26017d2`](https://github.com/tomhoover/git-wt/commit/26017d2bd61ac07ce36ef2d4690c377146278bdf)

### Documentation
- Changelog file generated [`ad3302c`](https://github.com/tomhoover/git-wt/commit/ad3302cba7fcc8d7c6f4ac44707d7a9fd63d7cd2)
## v0.21.2 (2026-03-12)

### Documentation
- Changelog file generated [`9ad5a7f`](https://github.com/tomhoover/git-wt/commit/9ad5a7f81bab8558ae15e6410cfeffdd07ca4e15)

### Test
- Preserve existing .git-wt-copy during no-copy test [`ae768e4`](https://github.com/tomhoover/git-wt/commit/ae768e442b0c5cbc0337c1e00b209eb9d7c915bc)
- Save/restore .git-wt-copy around every test via setup/teardown [`89319c3`](https://github.com/tomhoover/git-wt/commit/89319c3de6ec16540466240e2b08a149e5bc7171)
## v0.21.1 (2026-03-12)

### Bug Fixes
- Show resolved worktree name in remove success message [`03ed7da`](https://github.com/tomhoover/git-wt/commit/03ed7da80aece09a608998d0b05d9fb1e2ad85d7)

### Test
- Remove .git-wt-copy teardown_file cleanup [`ffaa0f8`](https://github.com/tomhoover/git-wt/commit/ffaa0f8b6406fbb5f315a39132616d7b9ddc88c5)
## v0.21.0 (2026-03-12)

### Documentation
- Changelog file generated [`19cb3de`](https://github.com/tomhoover/git-wt/commit/19cb3de3510d87b5661e891a129bf094d8451c9a)

### Feature
- Copy untracked files/dirs to new worktree via .git-wt-copy [`03236ae`](https://github.com/tomhoover/git-wt/commit/03236aebbe08ef5fed25950cbaa6d50d041e993a)
## v0.20.6 (2026-03-12)

### Documentation
- Changelog file generated [`8918fda`](https://github.com/tomhoover/git-wt/commit/8918fdabeff762ca6e4956c69fee9117da41b307)

### Test
- Fix version extraction after linter removed quotes from VERSION [`51a0295`](https://github.com/tomhoover/git-wt/commit/51a02954a281e0f6aeefb17fb2de9d56d060a9d7)
## v0.20.5 (2026-03-12)

### Bug Fixes
- Suppress phantom detached entry in list and status output [`4196b83`](https://github.com/tomhoover/git-wt/commit/4196b830ea3a23ed3ce66d4fa2cf616431bd1ea7)

### Documentation
- Changelog file generated [`845077a`](https://github.com/tomhoover/git-wt/commit/845077a99a1b88e93618218078714e1f338bb9e1)
## v0.20.4 (2026-03-10)

### Bug Fixes
- Wt cd nonexistent silently no-ops [`b41249b`](https://github.com/tomhoover/git-wt/commit/b41249b7a6ec613c9c00882af8601e3d1b869e0e)
## v0.20.3 (2026-03-10)

### Bug Fixes
- Reject flags that appear after the worktree name in remove command [`0c87185`](https://github.com/tomhoover/git-wt/commit/0c871852ad99261378401c43b0f67b67581fcb55)
## v0.20.2 (2026-03-10)

### Bug Fixes
- Distinguish directory missing vs inaccessible in list output [`3642b98`](https://github.com/tomhoover/git-wt/commit/3642b980deccf1775f389c3fd81be789202c1e6b)

### Documentation
- Changelog file generated [`022f0b0`](https://github.com/tomhoover/git-wt/commit/022f0b0dfeffa1ad11ebe3707045dd9df1c05196)
## v0.20.1 (2026-03-11)

### Bug Fixes
- Awk reads past detached-HEAD block when extracting branch for remove -d [`726e3f8`](https://github.com/tomhoover/git-wt/commit/726e3f88e7ffede683d0ac7fed60ad83bfb34bec)
## v0.20.0 (2026-03-10)

### Documentation
- Changelog file generated [`c989b1e`](https://github.com/tomhoover/git-wt/commit/c989b1eda48200dea63c3f7e52239043906bdc6a)

### Feature
- Automatically run mise trust on newly added worktree [`25936c0`](https://github.com/tomhoover/git-wt/commit/25936c059f4d4257788f757752b49826a61947e8)
## v0.19.4 (2026-03-10)

### Bug Fixes
- Distinguish broken (!!) from dirty (!) in list output (#11) [`030e7b7`](https://github.com/tomhoover/git-wt/commit/030e7b7f26e2590f57183be61d9f71a18441c02a)
- Show actionable git error when worktree add fails; fix list test regex [`2a201f6`](https://github.com/tomhoover/git-wt/commit/2a201f687f9fbeee181b909108375b877a96c599)

### Documentation
- Changelog file generated [`be62d1d`](https://github.com/tomhoover/git-wt/commit/be62d1d227dbdd3fa0565beeaed3d0be0a7ec99d)
- Changelog file generated [`dcd8805`](https://github.com/tomhoover/git-wt/commit/dcd8805c64dba8b1a548015802b1443146ca88a0)
## v0.19.3 (2026-03-10)

### Bug Fixes
- Detect broken/inaccessible worktrees in status and list; add test coverage for slash-branch remove and broken status [`02313e9`](https://github.com/tomhoover/git-wt/commit/02313e9a7c7b83cf21cc3006d0d5619b8c98d908)
## v0.19.2 (2026-03-10)

### Refactor
- Address inconsistencies and minor issues [`5c88b37`](https://github.com/tomhoover/git-wt/commit/5c88b378abb96c01fb7f9a5a1dfdb0a1a4ea50f9)
## v0.19.1 (2026-03-10)

### Bug Fixes
- Surface first-attempt error in add, detect broken worktrees in status, warn on detached-HEAD remove -d; add missing tests [`8b60a92`](https://github.com/tomhoover/git-wt/commit/8b60a92cad9d15aa53d99ac34db2e066d722ecfa)
## v0.19.0 (2026-03-10)

### CI
- Add Claude Code GitHub Workflow (#10) [`4418137`](https://github.com/tomhoover/git-wt/commit/441813766dfc548471e816f82670a9d27dd57168)

### Documentation
- Changelog file generated [`5cbcaad`](https://github.com/tomhoover/git-wt/commit/5cbcaad6616d97563a2cd2fc4f8672d7379820a0)
- Changelog file generated [`bf43ec4`](https://github.com/tomhoover/git-wt/commit/bf43ec457e7dfa7e0d7bce41da7096c11000d248)

### Feature
- Support slash branches and prefix matching in remove [`b719d8f`](https://github.com/tomhoover/git-wt/commit/b719d8f18a4c207b10372eb45121a3e9fc7801f7)
## v0.18.6 (2026-03-10)

### Documentation
- Document partial name matching and fzf behaviour for 'wt cd' [`4520463`](https://github.com/tomhoover/git-wt/commit/452046391c0ad464b5368ae0deccbb71a4d64415)
## v0.18.5 (2026-03-09)

### Refactor
- Remove dead variable, hoist locals, reduce git calls [`ac71895`](https://github.com/tomhoover/git-wt/commit/ac71895d95d304f0e4f6b469ff896f4f1465db1d)
## v0.18.4 (2026-03-09)

### Refactor
- Polish status_worktrees() and add_worktree() [`1cbef5b`](https://github.com/tomhoover/git-wt/commit/1cbef5b83bb3c6ec1b63c7d34fb7c21120d35851)
## v0.18.3 (2026-03-09)

### Refactor
- Clean up dead code and minor issues in src/git-wt [`2078290`](https://github.com/tomhoover/git-wt/commit/2078290095d5947941bbce97c01a900007b84b53)
## v0.18.2 (2026-03-09)

### Bug Fixes
- Sync completion files with embedded completions in src/git-wt [`97aabd5`](https://github.com/tomhoover/git-wt/commit/97aabd57e082af96fc4060f0e3d3da0f8c339cd7)

### Documentation
- Changelog file generated [`9401ac8`](https://github.com/tomhoover/git-wt/commit/9401ac8154203aff4571b55e67e48b79c3260e19)
## v0.18.1 (2026-03-09)

### Documentation
- :robot: changelog file generated [`c68e193`](https://github.com/tomhoover/git-wt/commit/c68e193bdd4799c3a605fc171c87de9b1da6f650)
- Remove obsolete -d and --verbose flags from README; bump to 0.18.1 [`a07c275`](https://github.com/tomhoover/git-wt/commit/a07c275526b4443588b1cf5152e04ab781ecab01)
## v0.18.0 (2026-03-09)

### Refactor
- Remove VERBOSE flag; prune always runs with -v [`0f4fd87`](https://github.com/tomhoover/git-wt/commit/0f4fd870bef47c66d76ee4ceecdf3c3a96edc3bb)
## v0.17.0 (2026-03-09)

### Bug Fixes
- Remove -d shorthand for --debug to resolve collision with --delete-branch [`296039c`](https://github.com/tomhoover/git-wt/commit/296039c4a2b27e395fae8f2c5f38bd973d9bc058)
## v0.16.5 (2026-03-09)

### Test
- Add bats_remote defensive cleanup to teardown_file [`e2b9f13`](https://github.com/tomhoover/git-wt/commit/e2b9f1360115bf4c813b211db7451a31c9dc4477)
## v0.16.4 (2026-03-09)

### Refactor
- Extract _git_wt_worktree_branches helper in zsh completion [`6a2cd77`](https://github.com/tomhoover/git-wt/commit/6a2cd77ab8cb85e955c24f7f3d25fdfc8cb77bea)
## v0.16.3 (2026-03-09)

### Chore
- Bump version to 0.16.3 [`039b7a7`](https://github.com/tomhoover/git-wt/commit/039b7a718dd3376b1c3c8c52db338f6b4263c501)
## v0.16.2 (2026-03-09)

### Chore
- Bump version to 0.16.2 [`bd809df`](https://github.com/tomhoover/git-wt/commit/bd809dfd9cdb5add613649fe9546177936122c32)

### Documentation
- :robot: changelog file generated [`2e21960`](https://github.com/tomhoover/git-wt/commit/2e219604baab3c2af2edde4e96b9e4350533d4d8)
## v0.16.1 (2026-03-09)

### CI
- Generate Changelog based on Conventional Commits [`b42ca7f`](https://github.com/tomhoover/git-wt/commit/b42ca7f831bfbc57c355dec409d5dd3d497bd2d8)
## v0.16.0 (2026-03-09)

### Feature
- Add --delete-branch flag to remove command [`ea8c447`](https://github.com/tomhoover/git-wt/commit/ea8c4472f47a0324049cedfd93bc87f975bd2115)
## v0.15.0 (2026-03-09)

### Feature
- Fzf integration for wt cd [`bdd49b5`](https://github.com/tomhoover/git-wt/commit/bdd49b5fdae0af870661d92376c5b0987afc2d3b)
## v0.14.0 (2026-03-09)

### CI
- Add GitHub Actions workflow to run lint and bats tests [`55ff344`](https://github.com/tomhoover/git-wt/commit/55ff344ca1911d33af7d58381bb9529b96a363c6)
- Checkout branch by name to avoid detached HEAD in tests [`2aee2fc`](https://github.com/tomhoover/git-wt/commit/2aee2fca96c0c5a6a1eb0fd7ca9c3f39d9fc171d)
- Ensure HEAD is on a named branch to fix list tests [`24dceb4`](https://github.com/tomhoover/git-wt/commit/24dceb40b1bbef7e48cd3d6f2212669a50eecc0a)

### Documentation
- Fix typo in README.md (#5) [`8e25e23`](https://github.com/tomhoover/git-wt/commit/8e25e237b4562c560d8442cbb3d85e9599fe49a7)

### Feature
- Add 'cd <TAB>' completion for wt alias [`4d46e53`](https://github.com/tomhoover/git-wt/commit/4d46e531cd7c2707a5a8cc0320dce83d738006bb)

### Test
- Add missing status tests for dirty worktree and current worktree marker [`00394d6`](https://github.com/tomhoover/git-wt/commit/00394d65b401d19ca0f70f545e5393b33619d0da)
- Add missing coverage for list, cd, and verbose flag tests [`be8f3e3`](https://github.com/tomhoover/git-wt/commit/be8f3e3919fb6ce8205e1d505d054d0d895c87ea)
- Broaden list assertions to match any branch name [`c6bf06b`](https://github.com/tomhoover/git-wt/commit/c6bf06b3265f3f9dabb61b0a83ccfba15b46421f)
## v0.13.0 (2026-03-09)

### Bug Fixes
- Exclude merge commits from conventional commit check [`733a91a`](https://github.com/tomhoover/git-wt/commit/733a91a7297bc1e1846d500b46ffb80e34eb284b)

### CI
- Add GitHub Actions workflow to enforce conventional commits [`fb91c3d`](https://github.com/tomhoover/git-wt/commit/fb91c3db580a8171c4a34b7474a588633823a16f)

### Feature
- Add a 'dirty' indicator to the 'list' command [`baefb5d`](https://github.com/tomhoover/git-wt/commit/baefb5dd6c2701d8a21b79a857e11cd8608adf09)
## v0.12.1 (2026-03-08)

### Documentation
- Add additional examples to 'Usage' [`e86225f`](https://github.com/tomhoover/git-wt/commit/e86225fbdc296d0f63a1f66bc11448047395e7f2)
## v0.12.0 (2026-03-08)

### Documentation
- Update README.md [`4784e26`](https://github.com/tomhoover/git-wt/commit/4784e26fdf197e92de946365b7bea3ec60708a3f)

### Feature
- Show wt-aware usage when called via wrapper function [`72d0d29`](https://github.com/tomhoover/git-wt/commit/72d0d29ac25e8ab7e718c396af75846291624da5)
## v0.11.1 (2026-03-08)

### Documentation
- Clarification of 'remove' command options (-f|--force) [`e4466bc`](https://github.com/tomhoover/git-wt/commit/e4466bc292e1736c3ea96d517467daf009031cad)
## v0.11.0 (2026-03-08)

### Documentation
- Add MIT license [`62c17d0`](https://github.com/tomhoover/git-wt/commit/62c17d026157ae9602fb9c805732c97175658a01)

### Feature
- Improve bash completion and move -f flag to remove subcommand [`a64eaae`](https://github.com/tomhoover/git-wt/commit/a64eaae860c38e2b1a6ea9d0e1d46e95f45d64bc)

### Refactor
- Vim folding [`6ec550d`](https://github.com/tomhoover/git-wt/commit/6ec550df300449969be595f25cd5bf442fd5b582)
## v0.10.0 (2026-03-07)

### Feature
- Rename switch→cd, add status subcommand [`fd1e110`](https://github.com/tomhoover/git-wt/commit/fd1e110519f7d9a0b22700bad4b636c077a25ccf)
## v0.9.0 (2026-03-07)

### Feature
- Add init subcommand for shell integration [`524414d`](https://github.com/tomhoover/git-wt/commit/524414da49566e094c9b161fcc5aedd721f45af2)
## v0.8.0 (2026-03-07)

### Chore
- Bump version to 0.8.0 [`39233b0`](https://github.com/tomhoover/git-wt/commit/39233b0828c55dd507ea69ec2bb110f27aa46cbe)

### Feature
- Add prefix matching to switch subcommand [`02ca2ee`](https://github.com/tomhoover/git-wt/commit/02ca2ee3bac94091e1d6ed200e852b23dcaa73c0)
## v0.7.2 (2026-03-07)

### Feature
- Show (new branch) or (existing branch) after add [`56b8634`](https://github.com/tomhoover/git-wt/commit/56b863498b8aea2c5d00c16958468dd42724aaa7)
## v0.7.1 (2026-03-07)

### Feature
- Improve list output with * marker and color [`fe3738c`](https://github.com/tomhoover/git-wt/commit/fe3738c0407f89f7938c2882c5a73788dc025e61)
## v0.7.0 (2026-03-06)

### Chore
- Bump version to 0.7.0 [`89b3787`](https://github.com/tomhoover/git-wt/commit/89b3787c83047536eecef78d0a74ecd33279f1c0)
- Add src/ to PATH via mise and update tests [`1bea9e0`](https://github.com/tomhoover/git-wt/commit/1bea9e0814ad050af9cc86a89321818a6896f5d3)
## v0.6.3 (2026-03-05)

### Documentation
- Remove development section from README [`8bb306e`](https://github.com/tomhoover/git-wt/commit/8bb306e3123b114a8cedc4ab8ea847c4befc741f)
## v0.6.2 (2026-03-05)

### Test
- Verify -v flag is forwarded to git worktree prune [`4c19923`](https://github.com/tomhoover/git-wt/commit/4c199234bea0bfbd2f94590c39b7821613d9d3e5)
## v0.6.1 (2026-03-05)

### Feature
- Add completion subcommand for eval-based shell setup [`6b216d0`](https://github.com/tomhoover/git-wt/commit/6b216d09967d606dee62d4a14f959eb7ce985b2b)
## v0.6.0 (2026-03-05)

### Chore
- Bump version to 0.5.1 [`31e3df4`](https://github.com/tomhoover/git-wt/commit/31e3df429454d64c448f9ae92ee83b02a30cb84a)
- Bump version to 0.6.0 [`4dbf3a4`](https://github.com/tomhoover/git-wt/commit/4dbf3a4c0223fff6fe730715d616c8fcd478d200)

### Feature
- Add shell completion for zsh and bash [`5fab33c`](https://github.com/tomhoover/git-wt/commit/5fab33c2feede78d94da906f39b9c8c35bbc5850)
## v0.5.1 (2026-03-05)

### Feature
- Switch with no args returns main worktree path [`2c2fe15`](https://github.com/tomhoover/git-wt/commit/2c2fe15158ff0255fbd7afc23315a280088b91ef)
## v0.5.0 (2026-03-05)

### Feature
- Add no-args support to add command [`a20e7df`](https://github.com/tomhoover/git-wt/commit/a20e7df4eff9e2726e462558bfe3f78048ce282e)
## v0.4.0 (2026-03-05)

### Chore
- Bump version to 0.4.0 [`1dc906d`](https://github.com/tomhoover/git-wt/commit/1dc906d94016467d510c2e9424e774a333a0dc8b)

### Feature
- Add switch command to print worktree path [`563761a`](https://github.com/tomhoover/git-wt/commit/563761a9b4ad0fc82456b3fe7c5923bfb9d61f69)
## v0.3.0 (2026-03-05)

### Chore
- Update pre-commit hooks [`e70de26`](https://github.com/tomhoover/git-wt/commit/e70de26de366df6c431c1f586086820c1d71ba80)
- Add tools to mise.toml [`c87015e`](https://github.com/tomhoover/git-wt/commit/c87015ed0cf7064cf383130f5634edb5da6ef172)
- Improve Makefile [`5678449`](https://github.com/tomhoover/git-wt/commit/56784494dec2ff9e9328bc9de0c638bc30915db2)

### Documentation
- Rewrite README [`ce04dbd`](https://github.com/tomhoover/git-wt/commit/ce04dbd6883a6f887738a8238695416aa6b71133)

### Refactor
- Rename test/.bats_deps to test/libs [`923ab11`](https://github.com/tomhoover/git-wt/commit/923ab113f37be71bfdece959fdb3faa48d8cb3de)

### Style
- Switch to 2-space indent [`dfc6e66`](https://github.com/tomhoover/git-wt/commit/dfc6e6668ac776491a6ff6da306d56c626ba8b11)
## v0.1.0 (2026-02-27)
