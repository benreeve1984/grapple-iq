# Contributing to Grapple IQ

Thank you for your interest in contributing to Grapple IQ! We welcome contributions from the community.

## How to Contribute

### Reporting Issues

1. Check existing issues to avoid duplicates
2. Use the issue template when available
3. Include:
   - Device model and firmware version
   - Steps to reproduce
   - Expected vs actual behavior
   - Screenshots if applicable

### Pull Requests

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Test on simulator and real device if possible
5. Commit with clear messages (`git commit -m 'Add amazing feature'`)
6. Push to your fork (`git push origin feature/amazing-feature`)
7. Open a Pull Request

### Development Guidelines

#### Code Style

- Follow existing Monkey C conventions in the codebase
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions focused and small

#### Testing

Before submitting:
1. Test in Connect IQ simulator
2. Test on at least one physical device if possible
3. Verify no memory leaks or excessive allocations
4. Check that FIT fields are recorded correctly

#### Memory Management

- Avoid allocations in the 1Hz compute() path
- Reuse objects where possible
- Test with memory viewer in simulator

### Feature Requests

1. Open an issue describing the feature
2. Explain the use case and benefits
3. Wait for discussion before implementing

## Code of Conduct

- Be respectful and constructive
- Welcome newcomers and help them get started
- Focus on what is best for the community
- Show empathy towards other community members

## Questions?

Feel free to open an issue for any questions about contributing.