//
//  DSPDefaults.h
//  DotSnap
//
//  Created by Robert Widmann on 7/25/13.
//
//

#ifndef DotSnap_DSPDefaults_h
#define DotSnap_DSPDefaults_h

#if defined(__cplusplus)
#define DOTSNAP_EXTERN extern "C"
#else
#define DOTSNAP_EXTERN extern
#endif

#define DOTSNAP_EXPORT DOTSNAP_EXTERN

DOTSNAP_EXPORT NSString *const DSPDefaultFilenameTemplateKey;

DOTSNAP_EXPORT NSString *const DSPLoadDotSnapAtStartKey;

DOTSNAP_EXPORT NSString *const DSPAddsTimestampKey;

DOTSNAP_EXPORT NSString *const DSPFilenameHistoryKey;

DOTSNAP_EXPORT NSString *const DSPAutosaveInputFieldKey;

DOTSNAP_EXPORT NSString *const DSPDefaultFilePathKey;

DOTSNAP_EXPORT NSString *const DSPHasShownPanelAtFirstLaunchKey;

#endif
