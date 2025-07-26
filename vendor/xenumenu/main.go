package main

import (
	"context"
	"encoding/json"
	"fmt"
	"log/slog"
	"os"
	"os/exec"

	"codeberg.org/helvetica/binfo"
	"fyne.io/fyne/v2"
	"fyne.io/fyne/v2/app"
	"fyne.io/fyne/v2/container"
	"fyne.io/fyne/v2/widget"
	"github.com/urfave/cli/v3"
)

var bi = binfo.MustGet()

type config struct {
	SpecPath string
	Verbose  bool
	Rowcols  int
	Exit     bool
}

func main() {
	cli.VersionPrinter = func(cmd *cli.Command) {
		_, _ = fmt.Fprintf(
			cmd.Root().Writer,
			"%s\n",
			bi.Summarize(
				cmd.Name,
				cmd.Version,
				binfo.Multiline|binfo.Build|binfo.VCS|binfo.Module|binfo.CGO,
			),
		)
	}

	cfg := config{}

	cliApp := &cli.Command{
		Name:    "xenumenu",
		Version: bi.Module.Version,
		Arguments: []cli.Argument{
			&cli.StringArg{
				Name:        "spec",
				Destination: &cfg.SpecPath,
			},
		},
		Flags: []cli.Flag{
			&cli.BoolFlag{
				Name:        "verbose",
				Usage:       "verbose output",
				Destination: &cfg.Verbose,
			},
			&cli.IntFlag{
				Name:        "rowcols",
				Usage:       "maximum rows or columns for the grid",
				Destination: &cfg.Rowcols,
			},
			&cli.BoolFlag{
				Name:        "exit",
				Usage:       "whether to exit the GUI and shutdown after running the command",
				Destination: &cfg.Exit,
			},
		},
		Action: func(context.Context, *cli.Command) error {
			rawSpec, err := os.ReadFile(cfg.SpecPath)
			if err != nil {
				os.Exit(1)
			}

			spec := Spec{}

			err = json.Unmarshal(rawSpec, &spec)
			if err != nil {
				slog.Error("decoding JSON input failed", "error", err)
				os.Exit(1)
			}

			for key, entry := range spec.Entries {
				if entry.Argv0 == "" {
					entry.Argv0 = entry.Program
					spec.Entries[key] = entry
				}
			}

			if cfg.Verbose {
				slog.Info("parsed spec", "spec", fmt.Sprintf("%#v", spec))
			}

			a := app.New()
			w := a.NewWindow("Xenumenu")

			displayEntries := []fyne.CanvasObject{}

			for _, entry := range spec.Entries {
				e := widget.NewButton(entry.DisplayName, func() {
					go func() {
						ps, err := entry.Run()

						if err != nil {
							if _, ok := err.(*exec.ExitError); ok {
								slog.Error("command failed", "error", err)
							} else {
								slog.Error("unable to run command", "error", err)
								if cfg.Exit {
									os.Exit(1)
								}
							}
						}

						if cfg.Exit {
							os.Exit(ps.ExitCode())
						}
					}()
				})
				displayEntries = append(displayEntries, e)
			}

			w.SetContent(container.NewAdaptiveGrid(
				cfg.Rowcols,
				displayEntries...,
			))

			w.ShowAndRun()

			return nil
		},
	}

	if err := cliApp.Run(context.Background(), os.Args); err != nil {
		slog.Error("application error", "error", err)
		os.Exit(1)
	}
}
