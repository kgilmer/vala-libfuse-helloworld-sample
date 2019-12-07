fuse_example_sources = [
  'main.vala',
]

libfuse_dep = dependency('fuse')
libfuse26_dep = declare_dependency(dependencies: [libfuse_dep],
                              compile_args: '-DFUSE_USE_VERSION=26')

fuse_example_deps = [
  dependency('glib-2.0'),
  dependency('gobject-2.0'),
  libfuse26_dep
]

executable('fuse-example', fuse_example_sources,
  vala_args: '--target-glib=2.58',  
  dependencies: fuse_example_deps,
  install: true,
)
