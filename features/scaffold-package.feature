Feature: Scaffold WP-CLI commands

  Scenario: Scaffold a WP-CLI command without tests
    Given an empty directory

    When I run `wp package path`
    Then save STDOUT as {PACKAGE_PATH}

    When I run `wp scaffold package wp-cli/foo --skip-tests`
    Then STDOUT should contain:
      """
      Success: Created package files
      """
    And the {PACKAGE_PATH}/local/wp-cli/foo/.gitignore file should exist
    And the {PACKAGE_PATH}/local/wp-cli/foo/.editorconfig file should exist
    And the {PACKAGE_PATH}/local/wp-cli/foo/.distignore file should exist
    And the {PACKAGE_PATH}/local/wp-cli/foo/.distignore file should contain:
      """
      .gitignore
      """
    And the {PACKAGE_PATH}/local/wp-cli/foo/composer.json file should exist
    And the {PACKAGE_PATH}/local/wp-cli/foo/composer.json file should contain:
      """
      "type": "wp-cli-package",
      """
    And the {PACKAGE_PATH}/local/wp-cli/foo/composer.json file should contain:
      """
      "homepage": "https://github.com/wp-cli/foo",
      """
    And the {PACKAGE_PATH}/local/wp-cli/foo/composer.json file should contain:
      """
      "license": "MIT",
      """
    And the {PACKAGE_PATH}/local/wp-cli/foo/composer.json file should contain:
      """
          "require": {
              "wp-cli/wp-cli": "^1.1.0"
          },
      """
    And the {PACKAGE_PATH}/local/wp-cli/foo/command.php file should exist
    And the {PACKAGE_PATH}/local/wp-cli/foo/CONTRIBUTING.md file should exist
    And the {PACKAGE_PATH}/local/wp-cli/foo/CONTRIBUTING.md file should contain:
      """
      Contributing
      """
    And the {PACKAGE_PATH}/local/wp-cli/foo/wp-cli.yml file should exist
    And the {PACKAGE_PATH}/local/wp-cli/foo/.travis.yml file should not exist

    When I run `wp --require={PACKAGE_PATH}/local/wp-cli/foo/command.php hello-world`
    Then STDOUT should be:
      """
      Success: Hello world.
      """

    When I run `cat {PACKAGE_PATH}/local/wp-cli/foo/wp-cli.yml`
    Then STDOUT should contain:
      """
      require:
        - command.php
      """

    When I run `cat {PACKAGE_PATH}/local/wp-cli/foo/.gitignore`
    Then STDOUT should contain:
      """
      .DS_Store
      """

    When I run `cat {PACKAGE_PATH}/local/wp-cli/foo/.editorconfig`
    Then STDOUT should contain:
      """
      This file is for unifying the coding style for different editors and IDEs
      """

    When I run `wp package uninstall wp-cli/foo`
    Then STDOUT should contain:
      """
      Success: Uninstalled package.
      """

  Scenario: Scaffold a WP-CLI command without using --require
    Given an empty directory

    When I run `wp scaffold package wp-cli/without-require --skip-tests`
    Then STDOUT should contain:
      """
      Success: Created package files
      """

    When I run `wp hello-world`
    Then STDOUT should be:
      """
      Success: Hello world.
      """

    When I run `wp package uninstall wp-cli/without-require`
    Then STDOUT should contain:
      """
      Success: Uninstalled package.
      """

  Scenario: Scaffold a package with an invalid name
    Given an empty directory

    When I try `wp scaffold package foo`
    Then STDERR should be:
      """
      Error: 'foo' is an invalid package name. Package scaffold expects '<author>/<package>'.
      """

  Scenario: Scaffold a WP-CLI command to a custom directory
    Given an empty directory

    When I run `wp scaffold package wp-cli/custom-directory --dir=custom-directory --skip-tests`
    Then STDOUT should contain:
      """
      Success: Created package files
      """
    And the custom-directory/.gitignore file should exist
    And the custom-directory/.editorconfig file should exist
    And the custom-directory/composer.json file should exist
    And the custom-directory/command.php file should exist
    And the custom-directory/wp-cli.yml file should exist
    And the custom-directory/.travis.yml file should not exist

    When I run `wp --require=custom-directory/command.php hello-world`
    Then STDOUT should be:
      """
      Success: Hello world.
      """
    When I run `wp package uninstall wp-cli/custom-directory`
    Then STDOUT should contain:
      """
      Success: Uninstalled package.
      """

  Scenario: Attempt to scaffold the same package twice
    Given an empty directory
    And a session file:
      """
      s
      s
      s
      s
      s
      s
      s
      s
      """

    When I run `wp scaffold package wp-cli/same-package --skip-tests`
    Then STDOUT should contain:
      """
      Success: Created package files
      """

    When I run `wp scaffold package wp-cli/same-package --skip-tests < session`
    And STDERR should contain:
      """
      Warning: File already exists
      """
    Then STDOUT should contain:
      """
      All package files were skipped
      """
    When I run `wp package uninstall wp-cli/same-package`
    Then STDOUT should contain:
      """
      Success: Uninstalled package.
      """

  Scenario: Scaffold a WP-CLI command with tests
    Given an empty directory

    When I run `wp package path`
    Then save STDOUT as {PACKAGE_PATH}

    When I run `wp scaffold package wp-cli/with-tests`
    Then STDOUT should contain:
      """
      Success: Created package files
      """
    And the {PACKAGE_PATH}/local/wp-cli/with-tests/.gitignore file should exist
    And the {PACKAGE_PATH}/local/wp-cli/with-tests/.editorconfig file should exist
    And the {PACKAGE_PATH}/local/wp-cli/with-tests/composer.json file should exist
    And the {PACKAGE_PATH}/local/wp-cli/with-tests/command.php file should exist
    And the {PACKAGE_PATH}/local/wp-cli/with-tests/wp-cli.yml file should exist
    And the {PACKAGE_PATH}/local/wp-cli/with-tests/.travis.yml file should exist
    And the {PACKAGE_PATH}/local/wp-cli/with-tests/features/bootstrap/Process.php file should exist
    And the {PACKAGE_PATH}/local/wp-cli/with-tests/features/bootstrap/ProcessRun.php file should exist

    When I run `wp --require={PACKAGE_PATH}/local/wp-cli/with-tests/command.php hello-world`
    Then STDOUT should be:
      """
      Success: Hello world.
      """
    When I run `wp package uninstall wp-cli/with-tests`
    Then STDOUT should contain:
      """
      Success: Uninstalled package.
      """

  Scenario: Scaffold a command with a custom homepage
    Given an empty directory

    When I run `wp package path`
    Then save STDOUT as {PACKAGE_PATH}

    When I run `wp scaffold package wp-cli/bar --homepage='http://apple.com'`
    Then STDOUT should contain:
      """
      Success: Created package files
      """
    And the {PACKAGE_PATH}/local/wp-cli/bar/composer.json file should exist
    And the {PACKAGE_PATH}/local/wp-cli/bar/composer.json file should contain:
      """
      "homepage": "http://apple.com",
      """
    When I run `wp package uninstall wp-cli/bar`
    Then STDOUT should contain:
      """
      Success: Uninstalled package.
      """

  Scenario: Use tilde for HOME in package directory path
    Given an empty directory

    When I run `wp scaffold package bar/foo --dir=~/foo --force --skip-tests --skip-readme`
    Then STDOUT should contain:
      """
      Success: Package installed.
      """
    And the /tmp/wp-cli-home/foo directory should exist
