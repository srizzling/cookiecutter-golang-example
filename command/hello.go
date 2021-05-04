package command

import (
	"flag"

	"github.com/mitchellh/cli"
)

type HelloWorld struct {
	Ui cli.Ui
}

var _ cli.Command = &HelloWorld{}

func (c *HelloWorld) Run(args []string) int {
	cmdFlags := flag.NewFlagSet("hello-world", flag.ExitOnError)

	cmdFlags.Usage = func() {
		c.Ui.Output(c.Help())
	}

	if err := cmdFlags.Parse(args); err != nil {
		return 1
	}

	c.Ui.Output("hello")
	return 0
}

func (c *HelloWorld) Synopsis() string {
	return "some synposis text"
}

func (c *HelloWorld) Help() string {
	return "some help text"
}
