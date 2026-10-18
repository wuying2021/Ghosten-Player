const alphaVersion = bool.fromEnvironment('ALPHA_VERSION');
const appVersion = String.fromEnvironment('BUILD_VERSION', defaultValue: 'Dev');
const buildDate = String.fromEnvironment('BUILD_DATE', defaultValue: '2024-03-12');
const repoAuthor = String.fromEnvironment('REPO_AUTHOR', defaultValue: 'GhostenEditor');
const repoName = String.fromEnvironment('REPO_NAME', defaultValue: 'Ghosten-Player');
const repoUrl = 'https://github.com/$repoAuthor/$repoName';
const updateUrl = 'https://api.github.com/repos/$repoAuthor/$repoName/releases';
const libmpvUrl = 'https://api.github.com/repos/$repoAuthor/libmpv-build/releases';
const sponsorUrl = 'https://raw.githubusercontent.com/$repoAuthor/$repoName/main/sponsor_list.txt';
const wikiUrl = 'https://raw.githubusercontent.com/$repoAuthor/$repoName/refs/heads/wiki/wiki.json';
const issueUrl = 'https://github.com/$repoAuthor/$repoName/issues';
const ua =
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.75 Safari/537.36';
const headerUserAgent = 'User-Agent';
const assetsLogo = 'assets/images/logo.png';
const assetsNoData = 'assets/images/no-data.png';
const appName = 'Ghosten Player';
const double kQrSize = 240;
