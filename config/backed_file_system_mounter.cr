BakedFileSystemMounter.assemble(["public"])

if LuckyEnv.production?
  STDERR.puts "Mounting from baked file system ..."
  BakedFileSystemStorage.mount
end
