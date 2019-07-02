//
//  fjfx.hpp
//  LogoDetector
//
//  Created by AKSA SDS on 15/02/2019.
//  Copyright © 2019 altaibayar tseveenbayar. All rights reserved.
//

#ifndef fjfx_hpp
#define fjfx_hpp

#ifdef __cplusplus
extern "C" {
#endif // __cplusplus
    
    // Error codes
#define FJFX_SUCCESS                         (0)     // Extraction succeeded, minutiae data is in output buffer.
#define FJFX_FAIL_IMAGE_SIZE_NOT_SUP         (1)     // Failed. Input image size was too large or too small.
#define FJFX_FAIL_EXTRACTION_UNSPEC          (2)     // Failed. Unknown error.
#define FJFX_FAIL_EXTRACTION_BAD_IMP         (3)     // Failed. No fingerprint detected in input image.
#define FJFX_FAIL_INVALID_OUTPUT_FORMAT      (7)     // Failed. Invalid output record type - only ANSI INCIT 378-2004 or ISO/IEC 19794-2:2005 are supported.
#define FJFX_FAIL_OUTPUT_BUFFER_IS_TOO_SMALL (8)     // Failed. Output buffer too small.
    
    // Output fingerprint minutiae data format (per CBEFF IBIA registry)
#define FJFX_FMD_ANSI_378_2004        (0x001B0201)   // ANSI INCIT 378-2004 data format
#define FJFX_FMD_ISO_19794_2_2005     (0x01010001)   // ISO/IEC 19794-2:2005 data format
    
    // Required output buffer size
#define FJFX_FMD_BUFFER_SIZE          (34 + 256 * 6) // Output data buffer must be at least this size, in bytes (34 bytes for header + 6 bytes per minutiae point, for up to 256 minutiae points)
    
    // Minutiae Extraction interface
    int fjfx_create_fmd_from_raw(
                                 const void *raw_image,                      // Input: image to convert.  The image must be grayscale (8 bits/pixel), no padding, bright field (dark fingerprint on white background), scan sequence consistent with ISO/IEC 19794-4:2005.
                                 const unsigned int  pixel_resolution_dpi,   // Must be between 300 and 1024 dpi; the resolution must be the same for horizontal and vertical size (square pixels)
                                 const unsigned int  height,                 // Height of the input image, in pixels. Physical height must be between 0.3 inches (7.62 mm) and 1.6 inches (40.6 mm)
                                 const unsigned int  width,                  // Width of the input image, in pixels. Physical height must be between 0.3 inches (7.62 mm) and 1.5 inches (38.1 mm)
                                 const unsigned int  output_fmd_data_format, // FJFX_FMD_ANSI_378_2004 or FJFX_FMD_ISO_19794_2_2005
                                 void  *fmd,                                 // Where to store resulting fingerprint minutiae data (FMD)
                                 unsigned int *size_of_fmd_ptr               // Input: fmd buffer size. Output: actual size of the FMD.
    );
    
    // Misc functions
    int fjfx_get_pid(unsigned int *feature_extractor); // Returns 2-byte vendor ID + 2-byte product ID.
    // Standard biometric component identifier per CBEFF registry
    // http://www.ibia.org/cbeff/iso/
    // http://www.ibia.org/base/cbeff/_biometric_org.phpx
    
#ifdef __cplusplus
}
#endif // __cplusplus
#endif /* fjfx_hpp */
