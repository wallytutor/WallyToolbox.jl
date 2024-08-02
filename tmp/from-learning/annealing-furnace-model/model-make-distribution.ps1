# Name of directory and exe.
$pkg = "model-backend-service"

# Remove old and create new distribution.
Remove-Item -Path $pkg -Recurse -Force -ErrorAction Ignore
Remove-Item -Path "$pkg.exe" -Recurse -Force -ErrorAction Ignore
New-Item -Path "." -Name $pkg -ItemType "directory"

# Copy .NET Core API.
$directory = "src/model-wrapper/bin/Release/netstandard2.0"
Copy-Item -Path "$directory/*.dll" -Destination $pkg

# Copy C++ API and external dependencies.
$directory = "src/model-core/bin/Release/"
Copy-Item -Path "$directory/*.dll" -Destination $pkg

# Remove directory.
#Remove-Item -Path $pkg -Recurse -Force -ErrorAction Ignore
