#ifndef __FUMES_CONFIG__
#define __FUMES_CONFIG__

#ifdef _WIN32
#  ifdef FUMESCORE_API
#    undef FUMESCORE_API
#  endif
#  ifdef FUMESCORE_EXPORTS
#    define FUMESCORE_API extern "C" __declspec(dllexport)
#  else
#    define FUMESCORE_API extern "C" __declspec(dllimport)
#  endif
#else
#  define FUMESCORE_API
#endif // (_WIN32)

#define FUMES_TEST FUMESCORE_API void

#endif // (__FUMES_CONFIG__)