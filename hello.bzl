read_script_template = """#!/bin/sh
echo "#################"
cat {FILE}
echo "#################"
"""

def _hello_impl(ctx):
    file_object = ctx.actions.declare_file("{}.txt".format(ctx.label.name))

    args = []
    args += ["--input_file", ctx.file._hello_tpl.path]
    args += ["--output_file", file_object.path]
    args += ["--string_to_replace", ctx.attr.string_to_replace]
    args += ["--replacement", ctx.attr.replacement]

    ctx.actions.run(
        executable = ctx.executable._transform,
        inputs = [ctx.file._hello_tpl],
        outputs = [file_object],
        arguments = args,
        progress_message = "Generating %s" % ctx.label.name,
        tools = [
            ctx.attr._transform.default_runfiles.files,
        ],
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
        "string_to_replace": attr.string(
            default = "{{REPLACE_ME}}",
        ),
        "replacement": attr.string(
            mandatory = True,
        ),
        "_hello_tpl": attr.label(
            allow_single_file = True,
            default = Label("//:hello_template.txt.tpl"),
        ),
        "_transform": attr.label(
            providers = [PyInfo],
            executable = True,
            cfg = "exec",
            default = Label("//tools:transform"),
        ),
    },
)
