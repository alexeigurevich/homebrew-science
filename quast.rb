class Quast < Formula
  desc "QUAST: Quality Assessment Tool for Genome Assemblies"
  homepage "http://quast.sourceforge.net"
  # doi "10.1093/bioinformatics/btt086", "10.1093/bioinformatics/btv697", "10.1093/bioinformatics/btw379"
  # tag "bioinformatics"

  url "http://quast.sf.net/quast-4.4.1.tar.gz"
  sha256 "e31510726b3dbcc43b866522191f936a5602b3247ef64a687fdcda674cbe38d0"

  bottle do
    cellar :any_skip_relocation
    sha256 "6f8e532693e2489a28a352b642b7e49142b1dd37592cf4d26050965d73f67fe6" => :el_capitan
    sha256 "64dd1f0cc101b783aa966dc95b043f58d63cbbc497e39b037660dd5f1742c6bf" => :yosemite
    sha256 "8dba14eebd1739ff6c5b1f71f05c25dc63d2239dcd73fdeba17385871662f1f4" => :mavericks
    sha256 "78bfe6cbc0a5fdbd7d8316a45a3dc5ad6d55141e3f8fa2cefb6f80d1fbb9f5ed" => :x86_64_linux
  end

  if OS.mac? && MacOS.version <= :mountain_lion
    depends_on "homebrew/python/matplotlib"
  else
    # Mavericks and newer include matplotlib
    depends_on "matplotlib" => :python
  end
  depends_on "e-mem"

  def install
    # removing precompiled E-MEM binaries causing troubles with brew audit
    mv "quast_libs/E-MEM-osx/nucmer", "quast_libs/"
    rm_r "quast_libs/E-MEM-osx"
    mkdir "quast_libs/E-MEM-osx"
    # QUAST needs quast_libs/E-MEM-osx/nucmer to ensure that E-MEM binaries are not working
    mv "quast_libs/nucmer", "quast_libs/E-MEM-osx/nucmer"
    prefix.install Dir["*"]
    bin.install_symlink "../quast.py", "../metaquast.py",
      "quast.py" => "quast", "metaquast.py" => "metaquast"
    # Compile MUMmer, so that `brew test quast` does not fail.
    system "#{bin}/quast", "--test"
  end

  test do
    system "#{bin}/quast", "--test"
  end
end
