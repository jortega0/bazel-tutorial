read_script_template = """#!/bin/sh
echo "#################"
cat {FILE}
echo "#################"
"""

def _hello_impl(ctx):
    file_object = ctx.actions.declare_file("{}.txt".format(ctx.label.name))

    ctx.actions.expand_template(
        template = ctx.file._hello_tpl,
        substitutions = {
            "{{REPLACE_ME}}": ctx.attr.input,
        },
        output = file_object,
    )

    read_script = ctx.actions.declare_file(ctx.label.name + "_read.sh")

    ctx.actions.write(
        content = read_script_template.format(FILE=file_object.short_path),
        output = read_script,
        is_executable = True,
    )

    runfiles = ctx.runfiles(files = [file_object, read_script])

    return [
        DefaultInfo(
            files = depset([file_object]),
            runfiles = runfiles,
            executable = read_script,
        ),
    ]

hello = rule(
    implementation = _hello_impl,
    executable = True,
    doc = "Writes a hello world Text file",
    attrs = {
        "input": attr.string(
            default = "World",
        ),
        "_hello_tpl": attr.label(
            allow_single_file = True,
            default = Label("//:hello_template.txt.tpl"),
        ),
    },
)
