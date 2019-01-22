const Generator = require('yeoman-generator')

module.exports = class extends Generator {
  prompting() {
    return this.prompt([
      {
        type: 'input',
        name: 'componentName',
        required: true,
        message:
          'Yo! What is the component name? (e.g. authentication or submission)',
      },
      {
        type: 'input',
        name: 'description',
        required: true,
        message:
          'Yo! What is the component description? (e.g. Hindawi implementation of the peer review process.)',
      },
    ]).then(answers => {
      this.componentName = answers.componentName
      this.description = answers.description
    })
  }

  writing() {
    // create the client file structure
    this.fs.copy(
      this.templatePath('client'),
      this.destinationPath(`packages/component-${this.componentName}/client`),
    )

    // create the server file structure
    this.fs.copy(
      this.templatePath('server'),
      this.destinationPath(`packages/component-${this.componentName}/server`),
    )

    // create the config file structure
    this.fs.copy(
      this.templatePath('config'),
      this.destinationPath(`packages/component-${this.componentName}/config`),
    )

    // create the package.json
    this.fs.copyTpl(
      this.templatePath('package.json'),
      this.destinationPath(
        `packages/component-${this.componentName}/package.json`,
      ),
      {
        componentName: this.componentName,
        description: this.description,
        projectVersion: '0.0.1',
      },
    )

    // create the package index
    this.fs.copy(
      this.templatePath('index.js'),
      this.destinationPath(`packages/component-${this.componentName}/index.js`),
    )
  }

  install() {
    this.installDependencies({
      npm: false,
      bower: false,
      yarn: true,
    })
  }
}
