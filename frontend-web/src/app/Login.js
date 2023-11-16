'use client'

import React, { useState } from 'react';
import { supabase } from '@/utils/supabaseClient';
import {
  Button,
  FormControl,
  FormLabel,
  Input,
  Stack,
  Box,
  Text
} from '@chakra-ui/react';


const Login = () => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);

  const handleEmailLogin = async (e) => {
    e.preventDefault();
    setLoading(true);

    const { error } = await supabase.auth.signInWithPassword({
      email: email,
      password: password,
    });
    if (error) {
      console.error('Error logging in:', error.message);
    } else {
      console.log('Logged in successfully');
    }

    setLoading(false);
  };

  const handleGoogleSignIn = async () => {
    const { error } = await supabase.auth.signInWithOAuth({
      provider: 'google',
    });
    if (error) {
      console.error('Error logging in with Google:', error.message);
    }
  };

  return (
    <Box p={4}>
      <Text fontSize="xl" mb={6}>Login</Text>
      <form onSubmit={handleEmailLogin}>
        <Stack spacing={3}>
          <FormControl isRequired>
            <FormLabel>Email</FormLabel>
            <Input
              type="email"
              placeholder="Enter your email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
            />
          </FormControl>
          <FormControl isRequired>
            <FormLabel>Password</FormLabel>
            <Input
              type="password"
              placeholder="Enter your password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
            />
          </FormControl>
          <Button
            type="submit"
            colorScheme="blue"
            isLoading={loading}
          >
            Log in
          </Button>
        </Stack>
      </form>
      <Button mt={4} onClick={handleGoogleSignIn} colorScheme="red">
        Sign in with Google
      </Button>
    </Box>
  );
};

export default Login;
