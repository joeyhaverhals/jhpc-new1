import React, { useState } from 'react';
import { AnimatePresence } from 'framer-motion';
import { useAuth } from '@/hooks/useAuth';
import Hero from '@/components/website/Hero';
import About from '@/components/website/About';
import Features from '@/components/website/Features';
import Services from '@/components/website/Services';
import Blog from '@/components/website/Blog';
import Testimonials from '@/components/website/Testimonials';
import FAQ from '@/components/website/FAQ';
import Contact from '@/components/website/Contact';
import AuthModal from '@/components/website/AuthModal';
import AccountButton from '@/components/website/AccountButton';
import ChatInterface from '@/components/chat/ChatInterface';
import LoadingSpinner from '@/components/ui/LoadingSpinner';

const Website: React.FC = () => {
  const [showAuthModal, setShowAuthModal] = useState(false);
  const { user, isLoading } = useAuth();

  if (isLoading) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-gray-900">
        <LoadingSpinner size="lg" />
      </div>
    );
  }

  return (
    <div className="relative min-h-screen bg-gray-900">
      {/* Fixed Header */}
      <header className="fixed top-0 left-0 right-0 z-50 px-6 py-4">
        <nav className="max-w-7xl mx-auto flex justify-between items-center">
          <div className="text-white font-bold text-xl">Your Logo</div>
          <AccountButton onLoginClick={() => setShowAuthModal(true)} />
        </nav>
      </header>

      {/* Main Content */}
      <main className="relative z-10">
        <Hero />
        <About />
        <Features />
        <Services />
        <Blog />
        <Testimonials />
        <FAQ />
        <Contact />
      </main>

      {/* Chat Interface - Only show for authenticated users */}
      {user && <ChatInterface />}

      {/* Auth Modal */}
      <AnimatePresence>
        {showAuthModal && (
          <AuthModal onClose={() => setShowAuthModal(false)} />
        )}
      </AnimatePresence>

      {/* Background Elements */}
      <div className="fixed inset-0 pointer-events-none z-0">
        <div className="absolute inset-0 bg-gradient-to-b from-purple-500/10 to-blue-500/10 mix-blend-overlay" />
        <div className="absolute inset-0 bg-[radial-gradient(ellipse_at_center,_var(--tw-gradient-stops))] from-purple-900/20 via-transparent to-transparent" />
      </div>
    </div>
  );
};

export default Website;
