class LegionCli < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for bi-directional sync between Markdown files and productivity services"
  homepage "https://github.com/endgame-build/legion-cli"
  license "MIT"
  head "https://github.com/endgame-build/legion-cli.git", branch: "main"

  # This will be updated automatically by the release workflow
  url "https://github.com/endgame-build/legion-cli-releases/releases/download/dev-b7158f0/legion_cli-0.1.dev20250630+gb7158f0.tar.gz"
  sha256 "595e5a2f2a46fb0d1d1b0198e853c319673b8664132fe7c0fd7eb58d09ca15d2"
  version "0.1.dev20250630+gb7158f0"

  depends_on "python@3.12"

  def install
    # Create a virtualenv in libexec
    venv = virtualenv_create(libexec, "python3.12")
    
    # Install the package and all dependencies
    system libexec/"bin/pip", "install", "--upgrade", "pip"
    system libexec/"bin/pip", "install", buildpath
    
    # Create wrapper script that ensures proper Python environment
    (bin/"legion").write <<~EOS
      #!/bin/bash
      exec "#{libexec}/bin/python" -m legion.main "$@"
    EOS
    
    # Make it executable
    (bin/"legion").chmod 0755
  end

  def caveats
    <<~EOS
      This formula installs the latest development version of legion-cli.
      
      For the stable version, use:
        brew install legion-cli/stable/legion-cli
      
      To configure legion-cli, run:
        legion init
        legion jira setup  # or other service setup commands
      
      For more information, see:
        https://github.com/endgame-build/legion-cli#installation
    EOS
  end

  test do
    # Test basic functionality
    assert_match "Legion", shell_output("#{bin}/legion --help")
    assert_match version.to_s, shell_output("#{bin}/legion version")
    
    # Test service listing
    output = shell_output("#{bin}/legion --help")
    assert_match "jira", output
    
    # Test that we can import the package
    system libexec/"bin/python", "-c", "import legion; print('Import successful')"
  end
end