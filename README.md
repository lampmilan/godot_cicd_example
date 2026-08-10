A simple Continuous Integration and Continuous Delivery (CI/CD) pipeline example for Godot using GitHub Actions and Itch.io Butler.

* **Automated Linting:** Runs GDScript static code analysis on every push and pull request.
* **Automated Unit Testing:** Executes test suites headlessly using the GUT (Godot Unit Test) framework.
* **Automated Itch.io Deployment:** Publishes web exports straight to your Itch.io page via Butler when a release tag is pushed.

### How CI/CD Pipeline Protects You (The Failed PR Example)

Automated testing isn't just about running scripts, it's about stopping broken code from ever reaching your players.

To demonstrate this, the repository includes a purposefully failed Pull Request showcasing a real-world scenario
* **The Change:** A developer wanted to make early-game enemies tougher, so they increased the mob's default health pool from 3 to 5 in Mob.gd.
* **The Hidden Bug:** A unit test (test_mob.gd) explicitly verified that a standard mob takes exactly 3 standard player attacks to die.
*  **The Pipeline Reaction:** When the branch was pushed, GitHub Actions ran the CI suite. GUT caught the balance mismatch and failed:
```Plaintext
    test_mob_takes_three_hits_to_die (res://tests/test_mob.gd) ... FAIL
        Expected health after 3 standard player attacks to be 0, but got 2.
        Assertion failed: Expected [0], got [2].
```
### Setting Up Your Own Pipeline
To use this workflow in your own Godot repository, you need to configure three repository secrets on GitHub (Settings -> Secrets and variables -> Actions):

| Secret Name  | Description |
| ------------- | ------------- |
| BUTLER_CREDENTIALS  | Your API key generated from your Itch.io developer settings  |
| ITCHIO_USERNAME  | Your Itch.io account username.  |
| ITCHIO_GAME_SLUG  | The URL slug of your game project on Itch.io.  |

### Triggering a Release

Daily Development: Push code to main or open Pull Requests to run linting and unit tests automatically.

Publishing to Itch.io: When you are ready to ship a build, create and push a Git tag:
```Bash
git tag 0.1.0
git push origin 0.1.0
```
The pipeline will automatically stamp the version, build the Web export, and push it live!
