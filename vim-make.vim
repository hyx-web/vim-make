function! BuildMake()
    let l:cc = input("C Compiler [gcc]: ", "gcc")
    let l:cxx = input("C++ Compiler [g++]: ", "g++")
    let l:build_type = tolower(input("Build Type (exec/static/shared) [exec]: ", "exec"))
    let l:header_deps = confirm("Enable header dependency tracking?", "&Yes\n&No", 1)
    let l:default_target = 'myapp'
    if l:build_type == 'static' | let l:default_target = 'libmyapp.a'
    elseif l:build_type == 'shared' | let l:default_target = 'libmyapp.so' | endif
    let l:target = input("Target [" . l:default_target . "]: ", l:default_target)
    let l:cflags = input("CFLAGS [-Wall -Wextra]: ", "-Wall -Wextra")
    let l:cxxflags = input("CXXFLAGS [-Wall -Wextra]: ", "-Wall -Wextra")
    let l:ldflags = input("LDFLAGS (e.g. -L./lib): ", "")
    let l:ldlibs = input("LDLIBS (e.g. -lm): ", "")
    let l:incflags = input("INCLUDE paths (-I): ", "-I./include")
    let l:dep_rules = []
    if l:header_deps == 1
        let l:dep_rules = [
            \ "",
            \ "DEPDIR = .deps",
            \ "DEPFLAGS = -MT $@ -MMD -MP -MF $(DEPDIR)/$*.d",
            \ "",
            \ "%.o: %.c $(DEPDIR)/%.d | $(DEPDIR)",
            \ "\t$(CC) $(CFLAGS) $(INC) $(DEPFLAGS) -c $< -o $@",
            \ "",
            \ "%.o: %.cpp $(DEPDIR)/%.d | $(DEPDIR)",
            \ "\t$(CXX) $(CXXFLAGS) $(INC) $(DEPFLAGS) -c $< -o $@",
            \ "",
            \ "$(DEPDIR):",
            \ "\t@mkdir -p $@",
            \ "",
            \ "DEPFILES = $(SRC:%.c=$(DEPDIR)/%.d) $(SRC:%.cpp=$(DEPDIR)/%.d)",
            \ "include $(wildcard $(DEPFILES))"]
    else
        let l:dep_rules = [
            \ "%.o: %.c",
            \ "\t$(CC) $(CFLAGS) $(INC) -c $< -o $@",
            \ "",
            \ "%.o: %.cpp",
            \ "\t$(CXX) $(CXXFLAGS) $(INC) -c $< -o $@"]
    endif
    let l:target_rules = []
    if l:build_type == 'static'
        let l:target_rules = [
            \ "$(TARGET): $(OBJ)",
            \ "\tar rcs $@ $^",
            \ "\tranlib $@"]
    elseif l:build_type == 'shared'
        let l:target_rules = [
            \ "$(TARGET): $(OBJ)",
            \ "\t$(CXX) -shared -o $@ $^ $(LDFLAGS) $(LDLIBS)"]
    else
        let l:target_rules = [
            \ "$(TARGET): $(OBJ)",
            \ "\t$(CXX) $(LDFLAGS) -o $@ $^ $(LDLIBS)"]
    endif
    let l:makefile_content = [
        \ "# Auto-generated Makefile",
        \ "CC = " . l:cc,
        \ "CXX = " . l:cxx,
        \ "CFLAGS = " . l:cflags,
        \ "CXXFLAGS = " . l:cxxflags,
        \ "INC = " . l:incflags,
        \ "LDFLAGS = " . l:ldflags,
        \ "LDLIBS = " . l:ldlibs,
        \ "TARGET = " . l:target,
        \ "SRC = $(wildcard *.c *.cpp)",
        \ "OBJ = $(patsubst %.c,%.o,$(patsubst %.cpp,%.o,$(SRC)))",
        \ "",
        \ ".PHONY: all clean",
        \ "all: $(TARGET)",
        \ ""] + l:target_rules + [
        \ ""] + l:dep_rules + [
        \ "",
        \ "clean:",
        \ "\trm -rf $(TARGET) $(OBJ) *.a *.so $(DEPDIR)",
        \ ""]
    if filereadable('Makefile')
        let l:choice = confirm("Makefile exists. Override?", "&Yes\n&No", 1)
        if l:choice != 1 | echo "Canceled" | return | endif
    endif
    call writefile(l:makefile_content, 'Makefile')
    echo "Makefile generated! Target: '" . l:target . "'"
endfunction

command! -nargs=0 BuildMake call BuildMake()
