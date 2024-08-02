# Manual clean, I don't trust Visual Studio.
Remove-Item -path samples/fumes-core-call/bin/ -recurse -Force -ErrorAction Ignore
Remove-Item -path samples/fumes-core-call/obj/ -recurse -Force -ErrorAction Ignore
Remove-Item -path samples/fumes-core-call/x64/ -recurse -Force -ErrorAction Ignore

Remove-Item -path samples/fumes-wrapper-call/bin/ -recurse -Force -ErrorAction Ignore
Remove-Item -path samples/fumes-wrapper-call/obj/ -recurse -Force -ErrorAction Ignore

Remove-Item -path src/fumes-core/bin/ -recurse -Force -ErrorAction Ignore
Remove-Item -path src/fumes-core/obj/ -recurse -Force -ErrorAction Ignore

Remove-Item -path src/fumes-wrapper/bin/ -recurse -Force -ErrorAction Ignore
Remove-Item -path src/fumes-wrapper/obj/ -recurse -Force -ErrorAction Ignore

Remove-Item -path tests/fumes-core-test/bin/ -recurse -Force -ErrorAction Ignore
Remove-Item -path tests/fumes-core-test/obj/ -recurse -Force -ErrorAction Ignore
Remove-Item -path tests/fumes-core-test/x64/ -recurse -Force -ErrorAction Ignore

Remove-Item -path tests/fumes-wrapper-test/bin/ -recurse -Force -ErrorAction Ignore
Remove-Item -path tests/fumes-wrapper-test/obj/ -recurse -Force -ErrorAction Ignore
Remove-Item -path tests/fumes-wrapper-test/x64/ -recurse -Force -ErrorAction Ignore
