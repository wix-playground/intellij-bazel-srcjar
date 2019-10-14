
def _gen_srcjar_impl(ctx):
    file = ctx.actions.declare_file(ctx.label.name + "/" + ctx.attr.file)

    ctx.actions.write(output = file, content = ctx.attr.content)

    ctx.actions.run_shell(
        inputs = [file] + ctx.files._jdk,
        outputs = [ctx.outputs.srcjar],
        command = "{jdk}/bin/jar cvf {out} -C {dir} .".format(
            jdk = ctx.attr._jdk[java_common.JavaRuntimeInfo].java_home,
            out = ctx.outputs.srcjar.path,
            dir = ctx.outputs.srcjar.dirname + "/" + ctx.label.name
        )
    )

    return struct(
        files = depset([ctx.outputs.srcjar]),
        srcjars = struct(srcjar = ctx.outputs.srcjar),
    )

gen_srcjar = rule(
    _gen_srcjar_impl,
    attrs = {
        "file": attr.string(),
        "content": attr.string(),
        "_jdk": attr.label(default = "@bazel_tools//tools/jdk:current_java_runtime", providers = [java_common.JavaRuntimeInfo]),
    },
    outputs =  {
        "srcjar": "%{name}.srcjar"
    },
)
