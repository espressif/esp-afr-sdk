# Utility functions for projects

#
# Utility function to evaluate components in project
#
function(__project_get_components components component_paths test_components test_component_paths)
    idf_build_get_property(_components __PROJECT_COMPONENTS)

    if(NOT _components)
        idf_build_get_property(_build_components BUILD_COMPONENTS)
        idf_build_get_property(prefix __PREFIX)

        list(SORT _build_components)

        foreach(build_component ${_build_components})
            __component_get_target(component_target "${build_component}")
            __component_get_property(_name ${component_target} COMPONENT_NAME)
            __component_get_property(_prefix ${component_target} __PREFIX)
            __component_get_property(_alias ${component_target} COMPONENT_ALIAS)
            __component_get_property(_dir ${component_target} COMPONENT_DIR)

            if(_prefix STREQUAL prefix)
                set(component ${_name})
            else()
                set(component ${_alias})
            endif()

            if(NOT _name STREQUAL "test")
                list(APPEND _components ${component})
                list(APPEND _component_paths ${_dir})
            else()
                list(APPEND _test_components ${component})
                list(APPEND _test_component_paths ${_dir})
            endif()
        endforeach()

        idf_build_set_property(__PROJECT_COMPONENTS "${_components}")
        idf_build_set_property(__PROJECT_COMPONENT_PATHS "${_component_paths}")
        idf_build_set_property(__PROJECT_TEST_COMPONENTS "${_test_components}")
        idf_build_set_property(__PROJECT_TEST_COMPONENT_PATHS "${_test_component_paths}")
    else()
        idf_build_get_property(_component_paths __PROJECT_COMPONENT_PATHS)
        idf_build_get_property(_test_components __PROJECT_TEST_COMPONENTS)
        idf_build_get_property(_test_component_paths __PROJECT_TEST_COMPONENT_PATHS)
    endif()

    set(${components} "${_components}" PARENT_SCOPE)
    set(${component_paths} "${_component_paths}" PARENT_SCOPE)
    set(${test_components} "${_test_components}" PARENT_SCOPE)
    set(${test_component_paths} "${_test_component_paths}" PARENT_SCOPE)
endfunction()

# idf_project_generate_description_file
#
# Generate project description in JSON format for use with external tools.
#
# @param[in] filename output file name; relative to build directory if not full path
function(idf_project_generate_description_file filename)
    idf_build_get_property(PROJECT_NAME PROJECT_NAME)
    idf_build_get_property(PROJECT_PATH PROJECT_DIR)
    idf_build_get_property(BUILD_DIR BUILD_DIR)
    idf_build_get_property(SDKCONFIG SDKCONFIG)
    idf_build_get_property(SDKCONFIG_DEFAULTS SDKCONFIG_DEFAULTS)
    idf_build_get_property(PROJECT_EXECUTABLE EXECUTABLE)
    idf_build_get_property(executable_name EXECUTABLE_NAME)
    set(PROJECT_BIN ${executable_name}.bin)
    idf_build_get_property(IDF_VER IDF_VER)

    idf_build_get_property(sdkconfig_cmake SDKCONFIG_CMAKE)
    include(${sdkconfig_cmake})
    idf_build_get_property(COMPONENT_KCONFIGS KCONFIGS)
    idf_build_get_property(COMPONENT_KCONFIGS_PROJBUILD KCONFIG_PROJBUILDS)

    idf_build_get_property(idf_path IDF_PATH)

    __project_get_components(components component_paths test_components test_component_paths)

    make_json_list("${components};${test_components}" build_components_json)
    make_json_list("${component_paths};${test_component_paths}" build_component_paths_json)

    get_filename_component(filename_abs ${filename} ABSOLUTE BASE_DIR ${BUILD_DIR})
    configure_file("${idf_path}/tools/cmake/project_description.json.in"
        "${filename_abs}")
endfunction()