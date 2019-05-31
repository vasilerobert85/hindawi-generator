const Generator = require('yeoman-generator')

const GENERATOR_TYPES = {
  component: 'component',
  microservice: 'microservice',
}

module.exports = class extends Generator {
  async prompting() {
    let answers
    const { packageType } = await this.prompt([
      {
        type: 'list',
        name: 'packageType',
        required: true,
        message: 'Yo! What kind of package do you want to create?',
        choices: [
          { name: 'Hindawi component', value: GENERATOR_TYPES.component },
          { name: 'Hindawi microservice', value: GENERATOR_TYPES.microservice },
        ],
      },
    ])

    if (packageType === GENERATOR_TYPES.component) {
      answers = await this.prompt([
        {
          type: 'input',
          name: 'packageName',
          required: true,
          message: 'What is the component name? (e.g. authentication or submission)',
        },
        {
          type: 'input',
          name: 'description',
          required: true,
          message:
            'What is the component description? (e.g. Hindawi implementation of the peer review process.)',
        },
      ])
    } else {
      answers = await this.prompt([
        {
          type: 'input',
          name: 'packageName',
          required: true,
          message: 'What is the microservice name? (e.g. file conversion)',
        },
        {
          type: 'input',
          name: 'description',
          required: true,
          message: 'What is the microservice supposed to do? (e.g. service used to convert files)',
        },
      ])
    }

    this.packageType = packageType
    this.answers = answers
  }

  writing() {
    const { packageName, description } = this.answers
    if (this.packageType === GENERATOR_TYPES.component) {
      this.fs.copy(
        this.templatePath('package/client'),
        this.destinationPath(`packages/component-${packageName}/client`),
      )

      this.fs.copy(
        this.templatePath('package/server'),
        this.destinationPath(`packages/component-${packageName}/server`),
      )

      this.fs.copy(
        this.templatePath('package/config'),
        this.destinationPath(`packages/component-${packageName}/config`),
      )

      this.fs.copyTpl(
        this.templatePath('package/package.json'),
        this.destinationPath(`packages/component-${packageName}/package.json`),
        {
          description,
          projectVersion: '0.0.1',
          componentName: packageName,
        },
      )

      this.fs.copy(
        this.templatePath('package/index.js'),
        this.destinationPath(`packages/component-${packageName}/index.js`),
      )
    }
  }

  install() {
    // this.installDependencies({
    //   npm: false,
    //   bower: false,
    //   yarn: true
    // })

    console.log('aici ar trebui sa vina isntall')
  }
}
