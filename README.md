## These scripts are used to generate and maintain the base project of a Poetry-based project.
To get started and create the base for your project, run the following command:

```shell
  source ./scripts/init.sh
```

Note: Once your project is created, it’s recommended to delete init.sh to prevent accidental regeneration.

### To run the setup script after your project is created:
```shell
  source ./scripts/setup.sh
```
This script should be run every time someone clones the repository to ensure the project is set up correctly.

### To run the application:
```shell
  ./scripts/run.sh
```

This is the entry point for your application.