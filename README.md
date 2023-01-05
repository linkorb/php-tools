# php-tools

A collection of tools to use in PHP-based projects for static analysis, unit/bdd testing, documentation, etc.

## Usage

PHP developers are agreeing that PHP tools should not be like regular composer dependencies (also not through require-dev), but instead be installed globally.

* https://twitter.com/s_bergmann/status/999635212723212288
* https://github.com/composer/composer/issues/5390
* https://github.com/composer/composer/issues/9636
* https://docs.phpdoc.org/2.9/getting-started/installing.html#using-composer ("we are unable to provide support on issues stemming from dependency conflicts")
* https://www.phpdoc.org/ (see "But wait? What about Composer?")

A primary reason for this is that adding many tools to require-dev significantly increases the complexity of the dependencies and constraints of your project. This can quickly lead to conflicts that are hard or impossible to solve. By installing these tools "globally", your project's dependencies will remain simple.

This repository contains the most commonly used PHP tools, so you can easily install them once, globally. You can then run these tools from all of your projects during testing, documentation generation, etc.

## Installation

    git clone https://github.com/linkorb/php-tools.git
    cd php-tools
    composer install # this recursively installs the tools inside of the `tools/` directory.

## Update your PATH environment variable

To make sure you can call the available tools from any (project) directory, you'll need to add this repository's `bin/` directory to your PATH environment variable:

    export PATH="/path/to/php-tools/bin:$PATH"

You can now confirm if you can successfully run `phpstan --help` from other directories.

To make this change permanent, add the previous line to your `~/.bashrc`, `~/.profile` or similar shell init script. Don't forget to start a new login session to check if it works.

If you're using [linuxserver's code-server](https://hub.docker.com/r/linuxserver/code-server), you can pass a PATH variable as part of your docker-compose.yml file.

## Alternatives

* Listing tools in "require-dev". This quickly leads to complex dependency conflicts (sometimes unsolvable)
* Installing tools with "composer global install". While this keeps your project dependencies simple, it still combines the constraints of all your tools, still leading to complex dependency graphs.
* Installing "phar" versions of your tools. Nice, but downloading and updating these executables is cumbersome
* Using [phive and phar.io](https://phar.io/) to manage your .phar executables. Not all tools are on phar.io, and leads to a lot of duplication
* Using [phpqa docker container](https://github.com/jakzal/phpqa). Complicated to reuse build configuration between local dev and CI (should be identical)
 
## How does it work?

In the `bin/` directory, you'll find a symlink for each of the available tools (phpstan, phpmd, phpcs, etc). These symlinks point to the tools themselves inside the tools/ directory.

This project uses [composer-bin-plugin](https://github.com/bamarni/composer-bin-plugin) to manage the `tools/` directory where every tool get's its own sub-directory (i.e. `tools/phpstan`).

Each of those sub-directories is a mini standalone composer project with a single dependency (the tool). You'll find a `composer.json` and a `composer.lock` file in each tool directory.

You can run `composer install` in the `php-tools` root directory, which will trigger a `composer install` inside each tool sub-directory too.

## Adding new tools

You can use the `composer-bin-plugin` to add new tools to the collection: 

    composer bin phpcs require squizlabs/php_codesniffer

* The name after `bin` is the name of the subdirectory in `tools/` that will be created for this tool.
* The part after `require` is the composer package name of the tool as it is registered on packagist.org

Finally, create a symlink to your newly added tool(s):

    cd bin/
    ln -s ../tools/phpcs/vendor/bin/phpcs bin/phpcs
    ln -s ../tools/phpcs/vendor/bin/phpcbf bin/phpcbf
    
Now commit:

* the tools/phpcs/composer.json and .lock files
* any symlinks you have created in `bin/`

The `.gitignore` file of this project should ensure you are not committing any vendor/ directories.

The `.gitattributes` ensures your composer.lock files are managed as "binary" files, to avoid merge conflicts.

## License

MIT. Please refer to the [license file](LICENSE) for details.

## Brought to you by the LinkORB Engineering team

<img src="http://www.linkorb.com/d/meta/tier1/images/linkorbengineering-logo.png" width="200px" /><br />
Check out our other projects at [linkorb.com/engineering](http://www.linkorb.com/engineering).

Btw, we're hiring!
