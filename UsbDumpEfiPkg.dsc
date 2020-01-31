##
 # File: UsbDumpEfiPkg.dsc
 #
 # Copyright (c) 2020 John Davis
 #
 # Permission is hereby granted, free of charge, to any person obtaining a copy
 # of this software and associated documentation files (the "Software"), to deal
 # in the Software without restriction, including without limitation the rights
 # to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 # copies of the Software, and to permit persons to whom the Software is
 # furnished to do so, subject to the following conditions:
 #
 # The above copyright notice and this permission notice shall be included in all
 # copies or substantial portions of the Software.
 #
 # THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 # IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 # FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 # AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 # LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 # OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 # SOFTWARE.
##

[Defines]
    PLATFORM_NAME           = UsbDumpEfiPkg
    PLATFORM_GUID           = E3B2B936-605D-44C3-8E89-39C7D59FF727
    PLATFORM_VERSION        = 1.0
    SUPPORTED_ARCHITECTURES = X64
    BUILD_TARGETS           = RELEASE|DEBUG
    SKUID_IDENTIFIER        = DEFAULT
    DSC_SPECIFICATION       = 0x00010006

[LibraryClasses]
    BaseLib|MdePkg/Library/BaseLib/BaseLib.inf
    BaseMemoryLib|MdePkg/Library/BaseMemoryLib/BaseMemoryLib.inf
    BaseSynchronizationLib|MdePkg/Library/BaseSynchronizationLib/BaseSynchronizationLib.inf
    DebugLib|MdePkg/Library/UefiDebugLibConOut/UefiDebugLibConOut.inf
    DebugPrintErrorLevelLib|MdePkg/Library/BaseDebugPrintErrorLevelLib/BaseDebugPrintErrorLevelLib.inf
    PrintLib|MdePkg/Library/BasePrintLib/BasePrintLib.inf
    DevicePathLib|MdePkg/Library/UefiDevicePathLib/UefiDevicePathLib.inf
    IoLib|MdePkg/Library/BaseIoLibIntrinsic/BaseIoLibIntrinsic.inf
    MemoryAllocationLib|MdePkg/Library/UefiMemoryAllocationLib/UefiMemoryAllocationLib.inf
    PcdLib|MdePkg/Library/BasePcdLibNull/BasePcdLibNull.inf
    TimerLib|MdePkg/Library/SecPeiDxeTimerLibCpu/SecPeiDxeTimerLibCpu.inf
    UefiApplicationEntryPoint|MdePkg/Library/UefiApplicationEntryPoint/UefiApplicationEntryPoint.inf
    UefiBootServicesTableLib|MdePkg/Library/UefiBootServicesTableLib/UefiBootServicesTableLib.inf
    UefiRuntimeServicesTableLib|MdePkg/Library/UefiRuntimeServicesTableLib/UefiRuntimeServicesTableLib.inf
    UefiDriverEntryPoint|MdePkg/Library/UefiDriverEntryPoint/UefiDriverEntryPoint.inf
    UefiFileHandleLib|MdePkg/Library/UefiFileHandleLib/UefiFileHandleLib.inf
    UefiLib|MdePkg/Library/UefiLib/UefiLib.inf
    UefiRuntimeServicesTableLib|MdePkg/Library/UefiRuntimeServicesTableLib/UefiRuntimeServicesTableLib.inf
    FileHandleLib|MdePkg/Library/UefiFileHandleLib/UefiFileHandleLib.inf
    SortLib|MdeModulePkg/Library/UefiSortLib/UefiSortLib.inf
    UefiHiiServicesLib|MdeModulePkg/Library/UefiHiiServicesLib/UefiHiiServicesLib.inf
    HiiLib|MdeModulePkg/Library/UefiHiiLib/UefiHiiLib.inf
    ShellLib|ShellPkg/Library/UefiShellLib/UefiShellLib.inf

[Components]
    UsbDumpEfiPkg/Application/UsbDumpEfi/UsbDumpEfi.inf

[PcdsFixedAtBuild]
    gEfiMdePkgTokenSpaceGuid.PcdMaximumAsciiStringLength|0
    !if $(TARGET) == DEBUG
        # DEBUG_ASSERT_ENABLED | DEBUG_PRINT_ENABLED | DEBUG_CODE_ENABLED | CLEAR_MEMORY_ENABLED | ASSERT_DEADLOOP_ENABLED
        gEfiMdePkgTokenSpaceGuid.PcdDebugPropertyMask|0x2f
        # DEBUG_ERROR | DEBUG_WARN | DEBUG_INFO
        gEfiMdePkgTokenSpaceGuid.PcdDebugPrintErrorLevel|0x80000042
        gEfiMdePkgTokenSpaceGuid.PcdFixedDebugPrintErrorLevel|0x80000042
    !endif

[BuildOptions]
    INTEL:DEBUG_*_*_CC_FLAGS    = -D DISABLE_NEW_DEPRECATED_INTERFACES
    INTEL:RELEASE_*_*_CC_FLAGS  = -D MDEPKG_NDEBUG -D DISABLE_NEW_DEPRECATED_INTERFACES
    GCC:DEBUG_*_*_CC_FLAGS      = -D DISABLE_NEW_DEPRECATED_INTERFACES
    GCC:RELEASE_*_*_CC_FLAGS    = -D MDEPKG_NDEBUG -D DISABLE_NEW_DEPRECATED_INTERFACES
    MSFT:DEBUG_*_*_CC_FLAGS     = -D DISABLE_NEW_DEPRECATED_INTERFACES
    MSFT:RELEASE_*_*_CC_FLAGS   = -D MDEPKG_NDEBUG -D DISABLE_NEW_DEPRECATED_INTERFACES
    XCODE:DEBUG_*_*_CC_FLAGS    = -D DISABLE_NEW_DEPRECATED_INTERFACES
    XCODE:RELEASE_*_*_CC_FLAGS  = -D MDEPKG_NDEBUG -D DISABLE_NEW_DEPRECATED_INTERFACES
