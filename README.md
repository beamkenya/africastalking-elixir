
# Contributing to AtEx

This is yet another Elixir wrapper for the [Africas Talking Api](https://build.at-labs.io/). Thanks for checking us out! We're excited to hear and learn from you. Your experiences will benefit others whon use,  want to and contribute to this library.

We've put together the following guidelines to help you getting started contributing to `AtEx` in the process you will figure out where you can best be helpful.

## Getting Started 
We love working and learning alongside the open source community and contributions are always welcome. We want to learn from you!
To start helping:
 - First go through this guideline to understand our contribution guideline and setting up locally. 
 - Then take a look at our issues and projects to see what you can work on.

## Table of Contents

0. [Types of contributions we're looking for](#types-of-contributions-were-looking-for)
0. [Roadmap and coverage](#roadmap-and-coverage)
0. [Ground rules & expectations](#ground-rules--expectations)
0. [How to contribute](#how-to-contribute)
0. [Style guide](#style-guide)
0. [Setting up your environment](#setting-up-your-environment)
0. [Community](#community)

## Types of contributions we're looking for
There are many ways you can directly contribute to the library:

* Working on existing issues.
* Fixing this documentation incase of any inconsistency.
* Adding PRs or issues that you come acrossw when using the library.

Interested in making a contribution? Read on!

## Roadmap and coverage
We hope to cover all the endpoints of [Africas Talking ](https://build.at-labs.io/discover) to help elixir developers integrate its services in their applications.
Here are the main modules we hope to develop in the process.
- [x] SMS
- [ ] Voice 
- [x] USSD 
- [x] Airtime
- [ ] Payments
- [ ] IoT
- [x] Application

## Ground rules & expectations

Before we get started, here are a few things we expect from you (and that you should expect from others):

* Be kind and thoughtful in your conversations around this project. We all come from different backgrounds and projects, which means we likely have different perspectives on "how open source is done." Try to listen to others rather than convince them that your way is correct.
* Open Source Guides are released with a [Contributor Code of Conduct](./CODE_OF_CONDUCT.md). By participating in this project, you agree to abide by its terms.
* If you open a pull request, please ensure that your contribution passes all tests. If there are test failures, you will need to address them before we can merge your contribution.
* When adding content, please consider if it is widely valuable. Please don't add references or links to things you or your employer have created as others will do so if they appreciate it.

## How to contribute

If you'd like to contribute, start by searching through the [issues](https://github.com/beamkenya/africastalking-elixir/issues) and [pull requests](https://github.com/beamkenya/africastalking-elixir/pulls) to see whether someone else has raised a similar idea or question.If you don't see your idea listed, and you think it fits into the goals of this library, do the following:

0. Find an issue that you are interested in addressing or a feature that you would like to add.
0. Fork the repository associated with the issue to your local GitHub organization. This means that you will have a copy of the repository under `your-GitHub-username/repository-name`.
0. Clone the repository to your local machine using `git clone https://github.com/beamkenya/africastalking-elixir.git`
0. Create a new branch for your fix using `git checkout -b your-branch-name-here`.
0. Make the appropriate changes for the issue you are trying to address or the feature that you want to add.
0. Use `git add insert-paths-of-changed-files-here` to add the file contents of the changed files to the "snapshot" git uses to manage the state of the project, also known as the index.
0. Use `git commit -m "Insert a short message of the changes made here"` to store the contents of the index with a descriptive message.
0. Push the changes to the remote repository using `git push origin your-branch-name-here`.
0. Submit a pull request to the upstream repository.
0. Title the pull request with a short description of the changes made and the issue or bug number associated with your change. For example, you can title an issue like so "Added more log outputting to resolve #4352".
0.In the description of the pull request, explain the changes that you made, any issues you think exist with the pull request you made, and any questions you have for the maintainers. It's OK if your pull request is not perfect (no pull request is), the reviewer will be able to help you fix any problems and improve it!
0. Wait for the pull request to be reviewed by a maintainer.
0. Make changes to the pull request if the reviewing maintainer recommends them.
0. Celebrate your success after your pull request is merged!

## Style guide
Ensure you run `mix format` to format the code to the best standards and limit failure when the CI runs.

## Setting up your environment

To start developing you need to have elixir and its tooling setup, then follow the instructions in [How to contribute](#how-to-contribute) above.

Once you have that set up locally, ensure you do the following:
- Create a `dev.exs` file under the `config` foilder in the root of the project. like `touch config/dev.exs`.
- Copy the contents of `dev.sample.exs` into the `dev.exs` created above.
- Go to [Africas Talking](https://account.africastalking.com/auth/register) to register for an account.
- On signing up go to the `https://account.africastalking.com/apps/sandbox`ntop get an **api key**
- Add the **api key** in the `api_key:`value in the `config/dev.exs` created above.

## Community

Discussions about the Library take place on this repository's [Issues](https://github.com/beamkenya/africastalking-elixir/issues) and [Pull Requests](https://github.com/beamkenya/africastalking-elixir/pulls) sections. Anybody is welcome to join these conversations. 

Wherever possible, do not take these conversations to private channels, including contacting the maintainers directly. Keeping communication public means everybody can benefit and learn from the conversation.


## Installation when testing locally
```elixir
def deps do
  [
    {:at_ex, git: "https://github.com/elixirkenya/africastalking-elixir"}
  ]
end
```
 Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/at_ex](https://hexdocs.pm/at_ex).
