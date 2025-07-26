package main

import (
	"os"
	"os/exec"
)

type SpecEntry struct {
	DisplayName string   `json:"displayName"`
	Program     string   `json:"program"`
	Args        []string `json:"args"`
	Argv0       string   `json:"argv0"`
	// TODO: env?
}

func (e SpecEntry) Run() (*os.ProcessState, error) {
	cmd := exec.Command(e.Program, e.Args...)
	cmd.Args[0] = e.Argv0

	cmd.Stdin = os.Stdin
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	return cmd.ProcessState, cmd.Run()
}

type Spec struct {
	Entries []SpecEntry `json:"entries"`
}
