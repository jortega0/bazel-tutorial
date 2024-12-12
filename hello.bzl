read_script_template = """#!/bin/sh
echo "#################"
cat {FILE}
echo "\n#################"
"""

def _hello_impl(ctx):
    file_object = ctx.actions.declare_file("{}.txt".format(ctx.label.name))

    content = "hello world!"

    ctx.actions.write(file_object, content, is_executable=False)

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
    doc = "Writes a hello world.txt file",
)
