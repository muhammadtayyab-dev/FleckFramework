//
//  fjfx.cpp
//  LogoDetector
//
//  Created by AKSA SDS on 15/02/2019.
//  Copyright © 2019 altaibayar tseveenbayar. All rights reserved.
//

#include <string.h>
#include "fjfx.hpp"
#include "FRFXLL.h"

#define CBEFF (0x00330502)

#define Check(x, err) { if ((x) < FRFXLL_OK) return err; }
#define CheckFx(x)    Check(x, FJFX_FAIL_EXTRACTION_UNSPEC);

struct dpHandle {
    FRFXLL_HANDLE h;
    
    dpHandle(FRFXLL_HANDLE _h = NULL) : h(_h) {}
    
    ~dpHandle() {
        if (h)
            Close();
    }
    
    FRFXLL_RESULT Close() {
        FRFXLL_RESULT rc = FRFXLL_OK;
        if (h) {
            rc = FRFXLLCloseHandle(h);
        }
        h = NULL;
        return rc;
    }
    
    operator FRFXLL_HANDLE() const  { return h; }
    FRFXLL_HANDLE* operator &()     { return &h; }
};

// Minutiae Extraction interface
int fjfx_create_fmd_from_raw(
                             const void *raw_image,
                             const unsigned int dpi,
                             const unsigned int height,
                             const unsigned int width,
                             const unsigned int output_format,
                             void   *fmd,
                             unsigned int *size_of_fmd_ptr
                             ) {
 
    if (fmd == NULL)       return FJFX_FAIL_EXTRACTION_UNSPEC;
    if (raw_image == NULL) return FJFX_FAIL_EXTRACTION_BAD_IMP;
    if (width > 2000 || height > 2000)                         return FJFX_FAIL_IMAGE_SIZE_NOT_SUP;
    if (dpi < 300 || dpi > 1024)                               return FJFX_FAIL_IMAGE_SIZE_NOT_SUP;
    if (width * 500 < 150 * dpi  || width * 500 > 812 * dpi)   return FJFX_FAIL_IMAGE_SIZE_NOT_SUP; // in range 0.3..1.62 in
    if (height * 500 < 150 * dpi || height * 500 > 1000 * dpi) return FJFX_FAIL_IMAGE_SIZE_NOT_SUP; // in range 0.3..2.0 in
    size_t size = size_of_fmd_ptr ? *size_of_fmd_ptr : FJFX_FMD_BUFFER_SIZE;
    if (size < FJFX_FMD_BUFFER_SIZE)                           return FJFX_FAIL_OUTPUT_BUFFER_IS_TOO_SMALL;
    FRFXLL_DATA_TYPE dt = 0;
    switch (output_format) {
        case FJFX_FMD_ANSI_378_2004:    dt = FRFXLL_DT_ANSI_FEATURE_SET; break;
        case FJFX_FMD_ISO_19794_2_2005: dt = FRFXLL_DT_ISO_FEATURE_SET; break;
        default:
            return FJFX_FAIL_INVALID_OUTPUT_FORMAT;
    }
    dpHandle hContext,hFtrSet;
    CheckFx(FRFXLLCreateLibraryContext(&hContext));
    switch (FRFXLLCreateFeatureSetFromRaw(hContext, reinterpret_cast<const unsigned char *>(raw_image), width*height, width, height, dpi, FRFXLL_FEX_ENABLE_ENHANCEMENT, &hFtrSet)) {
        case FRFXLL_OK:
            break;
        case FRFXLL_ERR_FB_TOO_SMALL_AREA:
            return FJFX_FAIL_EXTRACTION_BAD_IMP;
        default:
            return FJFX_FAIL_EXTRACTION_UNSPEC;
    }
    unsigned int dpcm =(dpi * 100 + 50) / 254;
    const unsigned char finger_quality =60;
    const unsigned char finger_position = 0;
    const unsigned char impression_type = 0;
    FRFXLL_OUTPUT_PARAM_ISO_ANSI param= {sizeof(FRFXLL_OUTPUT_PARAM_ISO_ANSI),CBEFF, finger_position,0, static_cast<unsigned short>(dpcm),static_cast<unsigned short>(dpcm), static_cast<unsigned short>(width), static_cast<unsigned short>(height),0 , finger_quality, impression_type};
    unsigned char * tmp1=reinterpret_cast<unsigned char*>(fmd);
    CheckFx(FRFXLLExport(hFtrSet, dt, &param, tmp1, &size));
    if(size_of_fmd_ptr) *size_of_fmd_ptr=size;
    
    return FJFX_SUCCESS;
}

