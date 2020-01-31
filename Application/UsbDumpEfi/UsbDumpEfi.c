/*
 * File: UsbDumpEfi.c
 *
 * Copyright (c) 2020 John Davis
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#include "UsbDumpEfi.h"

EFI_STATUS
EFIAPI
UsbDumpEfiMain (
  IN EFI_HANDLE       ImageHandle,
  IN EFI_SYSTEM_TABLE *SystemTable
  ) 
{
  Print(L"UsbDumpEfi start\n");

  EFI_STATUS    Status;
  UINTN         UsbHcCount;
  EFI_HANDLE    *UsbHcHandles;

  EFI_USB2_HC_PROTOCOL *UsbHc;

  UINT8   MaxSpeed;
  UINT8   Ports;
  UINT8 Is64Bit;

  EFI_USB_PORT_STATUS portStatus;

  Status = gBS->LocateHandleBuffer (ByProtocol, &gEfiUsb2HcProtocolGuid, NULL, &UsbHcCount, &UsbHcHandles);
  
  for (UINTN i = 0; i < UsbHcCount; i++) {
    Status = gBS->OpenProtocol (UsbHcHandles[i], &gEfiUsb2HcProtocolGuid, (VOID**)&UsbHc, NULL, ImageHandle, EFI_OPEN_PROTOCOL_GET_PROTOCOL);

    Status = UsbHc->GetCapability (UsbHc, &MaxSpeed, &Ports, &Is64Bit);

    Print (L"Found %u (%u ports, speed %u)\n", i, Ports, MaxSpeed);
    for (UINTN g = 0; g < Ports; g++) {
      Status = UsbHc->GetRootHubPortStatus (UsbHc, g, &portStatus);
      Print (L" Port %u status 0x%X, 0x%X\n", g, portStatus.PortStatus, portStatus.PortChangeStatus);
    }

    
  }

  return EFI_SUCCESS;
}
