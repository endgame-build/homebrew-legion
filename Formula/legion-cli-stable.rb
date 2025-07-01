class LegionCliStable < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for bi-directional sync between Markdown files and productivity services (stable)"
  homepage "https://github.com/endgame-build/legion-cli"
  license "MIT"

  # This will be updated when stable releases are made
  url "https://files.pythonhosted.org/packages/source/l/legion-cli/legion-cli-0.4.1.tar.gz"
  sha256 "0da2a0bdc00450f680a66a0125975b1cc94e84acebaaf9bd4a01e5e1083043d5"
  version "0.4.1"

  depends_on "python@3.12"

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/source/s/setuptools/setuptools-75.6.0.tar.gz"
    sha256 "0da2a0bdc00450f680a66a0125975b1cc94e84acebaaf9bd4a01e5e1083043d5"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/source/w/wheel/wheel-0.45.1.tar.gz"
    sha256 "0da2a0bdc00450f680a66a0125975b1cc94e84acebaaf9bd4a01e5e1083043d5"
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
      This is the stable version of legion-cli.
      
      For the latest development version, use:
        brew install legion-cli/dev/legion-cli
      
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