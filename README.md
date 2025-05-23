vim-make - Interactive Makefile Generator Plugin

Vim Plugin

License

A smart Makefile generation tool for C/C++ projects, creating build scripts through interactive Q&A to meet engineering requirements.
✨ Key Features

    ‌Interactive Configuration Wizard‌
    Customize compilers, build types, and compilation flags via command-line prompts.
    ‌Intelligent Rule Generation‌
    Auto-adapt build rules for executables/static libraries/shared libraries (exec/static/shared).
    ‌Header Dependency Tracking‌
    Optional generation of .deps directory for automated header dependency management.
    ‌Cross-Platform Support‌
    Compatible with GCC/Clang and works on Linux/macOS environments.
    ‌Safe Overwrite Protection‌
    Confirmation prompt before overwriting existing Makefiles.
    ‌Flexible Parameter Configuration‌
    Supports custom CFLAGS/CXXFLAGS/LDFLAGS and other compilation flags.

🛠️ Installation & Usage

    Save the plugin file to your Vim config directory (e.g., ~/.vim/plugin/).
    Execute in Vim:

    vimCopy Code
    :BuildMake

    Follow interactive prompts to configure your build.

🧩 Generated Example

makefileCopy Code
# Auto-generated Makefile
CC = gcc
CXX = g++
CFLAGS = -Wall -Wextra
CXXFLAGS = -Wall -Wextra
INC = -I./include
LDFLAGS = 
LDLIBS = 
TARGET = myapp
SRC = $(wildcard *.c *.cpp)
OBJ = $(patsubst %.c,%.o,$(patsubst %.cpp,%.o,$(SRC)))

.PHONY: all clean
all: $(TARGET)

$(TARGET): $(OBJ)
	$(CXX) $(LDFLAGS) -o $@ $^ $(LDLIBS)

# Auto-generated header dependencies
DEPDIR = .deps
DEPFLAGS = -MT $@ -MMD -MP -MF $(DEPDIR)/$*.d

%.o: %.c $(DEPDIR)/%.d | $(DEPDIR)
	$(CC) $(CFLAGS) $(INC) $(DEPFLAGS) -c $< -o $@

%.o: %.cpp $(DEPDIR)/%.d | $(DEPDIR)
	$(CXX) $(CXXFLAGS) $(INC) $(DEPFLAGS) -c $< -o $@

$(DEPDIR):
	@mkdir -p $@

DEPFILES = $(SRC:%.c=$(DEPDIR)/%.d) $(SRC:%.cpp=$(DEPDIR)/%.d)
include $(wildcard $(DEPFILES))

clean:
	rm -rf $(TARGET) $(OBJ) *.a *.so $(DEPDIR)

📚 Feature Details
Smart Default Configuration

    Auto-filled compilers (default: GCC/G++)
    Default build type: executable
    Automatic source file detection (.c/.cpp in current directory)

Advanced Dependency Management

makefileCopy Code
# Auto-generated header tracking
DEPFLAGS = -MT $@ -MMD -MP -MF $(DEPDIR)/%.d
# Automatic dependency inclusion
include $(wildcard $(DEPFILES))

Multi-Target Support
Build Type 	Output Example 	Linking Rule
exec 	myapp 	Direct executable link
static 	libmyapp.a 	Static library archive
shared 	libmyapp.so 	Shared library creation
⚙️ Customization Tips

Extend functionality by modifying parameters:

vimCopy Code
" Example: Add debug flags
let l:cflags = input("CFLAGS [-Wall -Wextra]: ", "-Wall -Wextra -g")

📜 License

Licensed under MIT License. Contributions and suggestions welcome.

‌Note:‌ This document was generated by AI.
