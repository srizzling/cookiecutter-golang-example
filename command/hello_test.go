package command

import (
	"encoding/json"
	"testing"

	"github.com/mitchellh/cli"
	"github.com/stretchr/testify/require"
)

func TestHelloWorld(t *testing.T) {
	testCases := []struct {
		desc string
		code int
		args []string
		want string
	}{
		{
			desc: "test simple use case of hello world",
			code: 0,
			args: []string{}
			want: "hello"
		},
	}
	for _, tC := range testCases {
		t.Run(tC.desc, func(t *testing.T) {
			// setup
			ui := new(cli.MockUi)
			c := &HelloWorld{UI: ui}
			code := c.Run(tC.args)

			// assert the return code
			require.Equal(t, tC.code, 0)

			// assert the output of the command
			got := ui.OutputWriter.String()
			require.Equal(t, got, tC.want)
		})
	}
}

