def _hello_impl(ctx):
    file_object = ctx.actions.declare_file("{}.txt".format(ctx.label.name))

    content = "hello world!"

    ctx.actions.write(file_object, content, is_executable=False)

    runfiles = ctx.runfiles(files = [file_object])

    return [
        DefaultInfo(
            files = depset([file_object]),
            runfiles = runfiles,
        ),
    ]

hello = rule(
    implementation = _hello_impl,
    executable = False,
    doc = "Writes a hello world.txt file",
)
