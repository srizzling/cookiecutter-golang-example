package main

import (
	"os"

	"github.com/srizzling/mygolangproject/command"
	"github.com/mitchellh/cli"
	log "github.com/sirupsen/logrus"
)

// these constants get overriden if you build a binary in the Makefile
var (
	Version    = "development"
	Commit     = "HEAD"
	Branch     = "HEAD"
	BinaryName = "command"
)

func main() {
	args := os.Args[1:]

	ui := &cli.BasicUi{Writer: os.Stdout}

	commands := map[string]cli.CommandFactory{
		"hello-world": func() (cli.Command, error) {
			return &command.HelloWorld{
				Ui: ui,
			}, nil
		},
	}

	// shortcut version to just show the version
	for _, arg := range args {
		if arg == "-v" || arg == "--version" {
			newArgs := make([]string, len(args)+1)
			newArgs[0] = "version"
			copy(newArgs[1:], args)
			args = newArgs
			break
		}
	}

	cli := &cli.CLI{
		Args:     args,
		Commands: commands,
		HelpFunc: cli.BasicHelpFunc(BinaryName),
		Version:  Version,
	}

	exitCode, err := cli.Run()
	if err != nil {
		log.WithError(err).Error("error executing cli")
		os.Exit(1)
	}
	os.Exit(exitCode)
}
