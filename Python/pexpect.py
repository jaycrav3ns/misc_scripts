import pexpect

   # `pexpect.spawn` starts the command.
   # `child.expect` waits for specific patterns and responds accordingly.
   # `child.before` contains the command output.

def my_command():
    # Command you want to run
    child = pexpect.spawn('my_command')

    # Send input as needed
    index = child.expect(['Enter your input:', pexpect.EOF])
    if index == 0:
        child.sendline('input_value')

    # Wait for completion
    child.expect(pexpect.EOF)

    # Print the output
    print("Command output:", child.before.decode('utf-8'))

if __name__ == "__main__":
    my_command()
