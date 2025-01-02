import React, { useState, useRef, useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { useNavigate } from 'react-router-dom';
import { 
  UserCircle, 
  LogOut, 
  Settings, 
  User, 
  LayoutDashboard,
  ChevronDown 
} from 'lucide-react';
import { useAuth } from '@/hooks/useAuth';

interface AccountButtonProps {
  onLoginClick: () => void;
}

const AccountButton: React.FC<AccountButtonProps> = ({ onLoginClick }) => {
  const { user, signOut } = useAuth();
  const [isOpen, setIsOpen] = useState(false);
  const dropdownRef = useRef<HTMLDivElement>(null);
  const navigate = useNavigate();

  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target as Node)) {
        setIsOpen(false);
      }
    };

    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  const handleSignOut = async () => {
    try {
      await signOut();
      setIsOpen(false);
      // Optionally redirect to home page
      navigate('/');
    } catch (error) {
      console.error('Error signing out:', error);
    }
  };

  const handleNavigation = (path: string) => {
    setIsOpen(false);
    navigate(path);
  };

  if (!user) {
    return (
      <button
        onClick={onLoginClick}
        className="px-6 py-3 bg-white/10 backdrop-blur-lg rounded-full 
                 text-white font-medium hover:bg-white/20 transition-all"
      >
        Sign In
      </button>
    );
  }

  return (
    <div className="relative" ref={dropdownRef}>
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="px-6 py-3 bg-white/10 backdrop-blur-lg rounded-full 
                 text-white font-medium hover:bg-white/20 transition-all
                 flex items-center space-x-2"
      >
        <UserCircle className="w-5 h-5" />
        <span className="hidden sm:inline">{user.email}</span>
        <ChevronDown className={`w-4 h-4 transition-transform ${isOpen ? 'rotate-180' : ''}`} />
      </button>

      <AnimatePresence>
        {isOpen && (
          <motion.div
            initial={{ opacity: 0, y: 10 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: 10 }}
            transition={{ duration: 0.2 }}
            className="absolute right-0 mt-2 w-64 bg-white/10 backdrop-blur-xl 
                     rounded-xl shadow-lg overflow-hidden z-50 border border-white/20"
          >
            {/* User Info */}
            <div className="p-4 border-b border-white/10">
              <p className="text-sm font-medium text-white truncate">
                {user.email}
              </p>
              <p className="text-xs text-white/60 mt-1 capitalize">
                {user.user_metadata?.role || 'User'}
              </p>
            </div>

            {/* Menu Items */}
            <div className="p-2">
              {/* Admin Dashboard - Only show for admin users */}
              {user.user_metadata?.role === 'admin' && (
                <button
                  onClick={() => handleNavigation('/admin')}
                  className="w-full flex items-center px-4 py-2 text-sm text-white hover:bg-white/10 
                           rounded-lg transition-colors"
                >
                  <LayoutDashboard className="w-4 h-4 mr-3" />
                  Admin Dashboard
                </button>
              )}

              {/* Profile */}
              <button
                onClick={() => handleNavigation('/profile')}
                className="w-full flex items-center px-4 py-2 text-sm text-white hover:bg-white/10 
                         rounded-lg transition-colors"
              >
                <User className="w-4 h-4 mr-3" />
                Profile
              </button>

              {/* Settings */}
              <button
                onClick={() => handleNavigation('/settings')}
                className="w-full flex items-center px-4 py-2 text-sm text-white hover:bg-white/10 
                         rounded-lg transition-colors"
              >
                <Settings className="w-4 h-4 mr-3" />
                Settings
              </button>

              {/* Divider */}
              <div className="my-2 border-t border-white/10" />

              {/* Sign Out */}
              <button
                onClick={handleSignOut}
                className="w-full flex items-center px-4 py-2 text-sm text-red-400 hover:bg-white/10 
                         rounded-lg transition-colors"
              >
                <LogOut className="w-4 h-4 mr-3" />
                Sign Out
              </button>
            </div>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
};

export default AccountButton;
