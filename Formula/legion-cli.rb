class LegionCli < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for bi-directional sync between Markdown files and productivity services"
  homepage "https://github.com/endgame-build/legion-cli"
  license "MIT"
  head "https://github.com/endgame-build/legion-cli.git", branch: "main"

  # This will be updated automatically by the release workflow
  url "https://github.com/endgame-build/legion-cli/archive/refs/tags/dev-placeholder.tar.gz"
  sha256 "placeholder-sha256"
  version "0.1.0-dev"

  depends_on "python@3.12"
  depends_on "uv" => :optional

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/source/s/setuptools/setuptools-75.6.0.tar.gz"
    sha256 "8199222558df7c86216af4f84c30e9b34a61d8ba19366cc914424cdbd28252f6"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/source/w/wheel/wheel-0.45.1.tar.gz"
    sha256 "661e1abd9198507b1409a20c02106d313e2a9e5f42f7895563e52ccb3d8d8b4"
  end

  def install
    # Create virtualenv
    venv = virtualenv_create(libexec, "python3.12")
    
    # Install build dependencies first
    venv.pip_install resources
    
    # Install legion-cli
    venv.pip_install_and_link buildpath
    
    # Generate shell completions if available
    generate_completions_from_executable(bin/"legion", shells: [:bash, :zsh, :fish],
                                        shell_parameter_format: :click)
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