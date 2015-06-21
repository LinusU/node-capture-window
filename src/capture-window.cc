
#include <node.h>
#include <nan.h>

#include "base.cc"

#ifdef __APPLE__
#include "apple.m"
#else
#error Platform not supported
#endif
