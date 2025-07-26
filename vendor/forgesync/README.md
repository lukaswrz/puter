# Forgesync

Forgesync automatically synchronizes all your Forgejo repositories to GitHub and any Forgejo instance such as Codeberg.

While Forgejo supports periodic Git mirroring out of the box, setting these mirrors up can be a lot of manual work. Forgesync resolves this by:

* Automatically creating target repositories  
* Syncing repository metadata (descriptions, topics, etc.)  
* Disabling issues and pull requests on the destination  
* Setting up mirrors directly within the source Forgejo instance  
* Filtering out forks, mirrors, and private repositories (only syncing what matters)

## Getting Forgesync

Currently, a Nix package is provided as part of this Nix flake. To use it in an ephemeral shell, run `nix shell git+https://codeberg.org/helvetica/forgesync.git`.

If you can't or don't want to use Nix for this, the best option right now is cloning the repository and using `uv run forgesync`.

## 💻 CLI usage

Here's how you would synchronize your Codeberg repositories to GitHub:

```bash
# Token for gathering source repository metadata and setting up mirrors.
export FROM_TOKEN=my_forgejo_token

# Token for creating and synchronizing repositories at the destination of your choosing.
export TO_TOKEN=my_github_token

# Token used within Forgejo for Git mirroring.
export MIRROR_TOKEN=my_github_mirror_token

# Run the sync:
forgesync \
  --from-instance https://codeberg.org/api/v1 \
  --to github \
  --to-instance https://api.github.com \
  --remirror \
  --mirror-interval 8h0m0s \
  --immediate \
  --log INFO
```

## ❄️ Usage as a NixOS module

Not yet.

## ⚠️ Be careful with your data!

> [!WARNING]
> Before running Forgesync, ensure you have backups. The tool will overwrite any repositories at the destination that share the same names as those on the source Forgejo instance. Proceed with caution.

## 🔑 Required token scopes

### Source (Forgejo)

Your `FROM_TOKEN` must have:

* **Repository:** read + write
* **User data:** read + write

### Destination (GitHub or Forgejo)

Your `TO_TOKEN` must have:

* **Repository:** read + write  
* **User data:** read + write

### Mirror Token

The `MIRROR_TOKEN` only needs:

* **Repository:** read + write

For GitHub fine-grained personal access tokens, this means that you will need to check "all repositories" under repository access and enable read and write permissions on repository contents.
