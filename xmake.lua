
add_rules("mode.debug", "mode.release")

set_targetdir("bin")
set_objectdir("bin-int")
set_rundir(".")

set_languages("clatest")
set_toolchains("nasm")

add_requires("glfw", "glad")

target("assembly-gl")
    set_kind("binary")
    add_files("src/**.asm", "src/**.c")

    add_includedirs("src")
    add_packages("glfw", "glad")
